import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapController {
  late GoogleMapController mapController;
  bool _mapLoaded = false;
  bool _errorLoadingMap = false;

  final LatLng _initialPosition = const LatLng(-5.1619, -38.1190);
  final Set<Marker> _markers = {};
  late final SupabaseClient _supabase;
  late final RealtimeChannel _vehicleCoordinatesChannel;

  Future<void> initializeSupabase() async {
    _supabase = Supabase.instance.client;
    await _subscribeToVehicleCoordinates();
    await _loadMarkersFromDatabase();
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

  Future<void> _subscribeToVehicleCoordinates() async {
    _vehicleCoordinatesChannel = _supabase
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'vehicle_coordinates',
          callback: (payload) {
            final record = payload.newRecord;
            _updateMarkerPosition(VehicleCoordinates.fromMap(record));
          },
        )
        .subscribe();
  }

  Future<void> _loadMarkersFromDatabase() async {
    try {
      final response = await _supabase.from('vehicle_coordinates').select();
      final data = response as List<dynamic>;

      _markers.clear();
      for (var record in data) {
        _updateMarkerPosition(VehicleCoordinates.fromMap(Map<String, dynamic>.from(record)));
      }
    } catch (e) {
      print('Erro ao carregar marcadores: $e');
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
