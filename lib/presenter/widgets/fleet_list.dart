﻿import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FleetList extends StatelessWidget {
  const FleetList({
    super.key,
    required this.onCardClick,
    required this.onButtonClick,
    required this.fleetList,
  });

  final Future<void> Function(Map<String, dynamic>) onCardClick;
  final Function() onButtonClick;
  final List<Map<String, dynamic>> fleetList;

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
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 300));
                    await onCardClick(vehicle);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_car,
                            ),
                            Expanded(
                              child: Text(
                                vehicle['plate_number'] ?? 'Sem placa',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(
                              Icons.speed,
                            ),
                            const Text('5 Km/h'),
                            const SizedBox(
                              width: 15,
                            ),
                            const Icon(Icons.emoji_transportation),
                            Text('${mileageFormat.format(vehicle['mileage'] ?? 0)} Km'),
                          ],
                        ),
                      ],
                    ),
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
