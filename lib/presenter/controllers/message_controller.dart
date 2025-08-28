import 'package:flutter/material.dart';
import 'package:drivemanager/data/repository/vehicle_repository.dart';
import 'package:drivemanager/data/repository/vehicle_coordinates_repository.dart';
import 'package:drivemanager/domain/usecase/request_support.dart';

class MessageController {
  final RequestSupport _requestSupport;

  MessageController({
    required VehicleRepository vehicleRepository,
    required VehicleCoordinatesRepository vehicleCoordinatesRepository,
  }) : _requestSupport = RequestSupport(vehicleRepository, vehicleCoordinatesRepository);

  Future<void> requestSupport(BuildContext context, String plateNumber) async {
    try {
      final success = await _requestSupport.execute(plateNumber);
      if (success) {
        _showDialog(
          context,
          'Solicitação de Suporte para $plateNumber',
          'Suporte enviado com sucesso!',
          Icons.check,
          Colors.green,
        );
      }
    } catch (e) {
      _showDialog(
        context,
        'Erro',
        'Ocorreu um erro: $e',
        Icons.error,
        Colors.red,
      );
    }
  }

  void _showDialog(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(content)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
