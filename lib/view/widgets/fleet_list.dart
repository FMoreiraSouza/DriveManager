import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drivemanager/data/model/vehicle.dart';

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

  // Método auxiliar para encontrar coordenadas por IMEI
  VehicleCoordinates? _findCoordinatesByImei(int? imei) {
    if (imei == null) return null;
    try {
      return coordinatesList.firstWhere(
        (coord) => coord.imei == imei,
      );
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

              final mileage = vehicle.mileage;
              final isStopped = coordinates?.isStopped ?? true;
              final speed = coordinates?.speed ?? 0.0;

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_car),
                          Expanded(
                            child: Text(
                              vehicle.plateNumber,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              color: isStopped ? Colors.red : Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.speed),
                          Text('${mileageFormat.format(speed)} Km/h'),
                          const SizedBox(width: 15),
                          const Icon(Icons.emoji_transportation),
                          Text('${mileageFormat.format(mileage)} Km'),
                        ],
                      ),
                    ],
                  ),
                ),
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
