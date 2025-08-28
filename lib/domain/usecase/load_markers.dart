import 'dart:ui';

import 'package:drivemanager/data/repository/vehicle_coordinates_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoadMarkers {
  final VehicleCoordinatesRepository _vehicleCoordinatesRepository;

  LoadMarkers(this._vehicleCoordinatesRepository);

  Future<Set<Marker>> execute() async {
    final coordinates = await _vehicleCoordinatesRepository.fetchCoordinates();
    final markers = <Marker>{};
    for (var coord in coordinates) {
      if (coord.imei != null) {
        final imei = coord.imei.toString();
        final icon = await _getMarkerIcon(imei);
        markers.add(
          Marker(
            markerId: MarkerId(imei),
            position: LatLng(coord.latitude, coord.longitude),
            infoWindow: InfoWindow(title: imei),
            icon: icon,
          ),
        );
      }
    }
    return markers;
  }

  Future<BitmapDescriptor> _getMarkerIcon(String imei) async {
    const iconPath = 'assets/icons/marker.png';
    return BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      iconPath,
    );
  }
}
