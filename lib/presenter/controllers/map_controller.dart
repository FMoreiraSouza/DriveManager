import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:drivemanager/data/repository/vehicle_coordinates_repository.dart';
import 'package:drivemanager/domain/usecase/load_markers.dart';
import 'package:drivemanager/domain/usecase/subscribe_to_vehicles_coordinates.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapController {
  late GoogleMapController mapController;
  bool _mapLoaded = false;
  bool _errorLoadingMap = false;

  final LatLng _initialPosition = const LatLng(-5.1619, -38.1190);
  final Set<Marker> _markers = {};
  final LoadMarkers _loadMarkers;
  final SubscribeToVehicleCoordinates _subscribeToVehicleCoordinates;
  late final RealtimeChannel _vehicleCoordinatesChannel;

  MapController({
    required VehicleCoordinatesRepository vehicleCoordinatesRepository,
    required SupabaseClient supabase,
  })  : _loadMarkers = LoadMarkers(vehicleCoordinatesRepository),
        _subscribeToVehicleCoordinates = SubscribeToVehicleCoordinates(supabase);

  Future<void> initializeSupabase() async {
    await _subscribeToCoordinates();
    await _fetchMarkers();
  }

  Future<void> loadMap(Function(bool) onMapLoaded, Function(bool) onErrorLoadingMap) async {
    try {
      onErrorLoadingMap(false);
      await Future.delayed(const Duration(seconds: 2));
      _mapLoaded = true;
      onMapLoaded(true);
    } catch (e) {
      _errorLoadingMap = true;
      onErrorLoadingMap(true);
    }
  }

  Future<void> _subscribeToCoordinates() async {
    _vehicleCoordinatesChannel = _subscribeToVehicleCoordinates.execute(_updateMarkerPosition);
  }

  Future<void> _fetchMarkers() async {
    try {
      _markers.clear();
      _markers.addAll(await _loadMarkers.execute());
    } catch (e) {
      throw Exception('Erro ao carregar marcadores: $e');
    }
  }

  Future<void> _updateMarkerPosition(VehicleCoordinates coord) async {
    if (coord.imei != null) {
      final imei = coord.imei.toString();
      final icon = await _getMarkerIcon(imei);

      _markers.removeWhere((marker) => marker.markerId.value == imei);
      _markers.add(
        Marker(
          markerId: MarkerId(imei),
          position: LatLng(coord.latitude, coord.longitude),
          infoWindow: InfoWindow(title: imei),
          icon: icon,
        ),
      );
    }
  }

  Future<BitmapDescriptor> _getMarkerIcon(String imei) async {
    const iconPath = 'assets/icons/marker.png';
    return BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      iconPath,
    );
  }

  void dispose() {
    _vehicleCoordinatesChannel.unsubscribe();
  }

  Set<Marker> get markers => _markers;
  LatLng get initialPosition => _initialPosition;
  bool get mapLoaded => _mapLoaded;
  bool get errorLoadingMap => _errorLoadingMap;
}
