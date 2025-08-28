import 'package:drivemanager/data/model/notification.dart';
import 'package:drivemanager/data/repository/vehicle_coordinates_repository_impl.dart';
import 'package:drivemanager/data/repository/vehicle_repository_impl.dart';
import 'package:drivemanager/presenter/controllers/message_controller.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.messages,
  });

  final List<Notification> messages;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final supabaseClient = Supabase.instance.client;
  late final MessageController messageController;

  @override
  void initState() {
    super.initState();
    messageController = MessageController(
      vehicleRepository: VehicleRepositoryImpl(supabaseClient),
      vehicleCoordinatesRepository: VehicleCoordinatesRepositoryImpl(supabaseClient),
    );
  }

  Future<void> _handleRequestSupport(String plateNumber) async {
    try {
      final success = await messageController.requestSupport(plateNumber);

      if (success && mounted) {
        _showDialog(
          'Solicitação de Suporte para $plateNumber',
          'Suporte enviado com sucesso!',
          Icons.check,
          Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        _showDialog(
          'Erro',
          'Ocorreu um erro: $e',
          Icons.error,
          Colors.red,
        );
      }
    }
  }

  void _showDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagens'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: widget.messages.map((message) {
          return ListTile(
            leading: const Icon(
              Icons.settings,
              size: 40.0,
              color: Colors.green,
            ),
            title: Text(
              message.plateNumber ?? 'Sem placa',
            ),
            subtitle: Text(
              message.message,
            ),
            trailing: TextButton(
              onPressed: () {
                if (message.plateNumber != null) {
                  _handleRequestSupport(message.plateNumber!);
                }
              },
              child: const Text('Solicitar Suporte'),
            ),
          );
        }).toList(),
      ),
    );
  }
}
