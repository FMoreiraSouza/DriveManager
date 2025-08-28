import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/data/model/vehicle.dart';

class MessageController {
  final SupabaseClient supabaseClient;

  MessageController(this.supabaseClient);

  Future<void> requestSupport(BuildContext context, String plateNumber) async {
    try {
      final response =
          await supabaseClient.from('vehicles').select().eq('plate_number', plateNumber).single();

      final vehicle = Vehicle.fromMap(response);
      if (vehicle.imei == null) {
        _showDialog(
          context,
          'Erro',
          'Veículo com placa $plateNumber não encontrado ou IMEI inválido.',
          Icons.error,
          Colors.red,
        );
        return;
      }

      final updateResponse = await supabaseClient
          .from('vehicle_coordinates')
          .update({'isStopped': false}).eq('imei', vehicle.imei!);

      if (updateResponse == null) {
        _showDialog(
          context,
          'Solicitação de Suporte para $plateNumber',
          'Suporte enviado com sucesso!',
          Icons.check,
          Colors.green,
        );
      } else {
        _showDialog(
          context,
          'Erro ao solicitar suporte para $plateNumber',
          'Ocorreu um erro ao tentar enviar a solicitação de suporte.',
          Icons.error,
          Colors.red,
        );
      }
    } catch (e) {
      _showDialog(
        context,
        'Erro',
        'Ocorreu um erro inesperado: $e',
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
