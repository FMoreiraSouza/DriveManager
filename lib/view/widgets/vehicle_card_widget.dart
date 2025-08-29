import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:drivemanager/data/model/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleCardWidget extends StatelessWidget {
  final Vehicle vehicle;
  final VehicleCoordinates? coordinates;
  final NumberFormat mileageFormat;

  const VehicleCardWidget({
    super.key,
    required this.vehicle,
    required this.coordinates,
    required this.mileageFormat,
  });

  @override
  Widget build(BuildContext context) {
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
                Text('${mileageFormat.format(vehicle.mileage)} Km'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
