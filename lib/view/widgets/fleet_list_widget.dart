import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drivemanager/data/model/vehicle.dart';
import 'package:drivemanager/view/widgets/vehicle_card_widget.dart';

class FleetList extends StatelessWidget {
  const FleetList({
    super.key,
    this.onButtonClick,
    required this.fleetList,
    required this.coordinatesList,
  });

  final VoidCallback? onButtonClick;
  final List<Vehicle> fleetList;
  final List<VehicleCoordinates> coordinatesList;

  VehicleCoordinates? _findCoordinatesByImei(int? imei) {
    if (imei == null) return null;
    try {
      return coordinatesList.firstWhere((coord) => coord.imei == imei);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat mileageFormat = NumberFormat("#,##0.0", "pt_BR");

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ListView.builder(
            itemCount: fleetList.length,
            itemBuilder: (context, index) {
              final vehicle = fleetList[index];
              final coordinates = _findCoordinatesByImei(vehicle.imei);

              return VehicleCardWidget(
                vehicle: vehicle,
                coordinates: coordinates,
                mileageFormat: mileageFormat,
              );
            },
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: onButtonClick,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
