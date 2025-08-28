import 'package:drivemanager/data/model/notification.dart';
import 'package:drivemanager/data/repository/vehicle_repository.dart';
import 'package:drivemanager/data/repository/vehicle_coordinates_repository.dart';
import 'package:drivemanager/presenter/controllers/message_controller.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    required this.messages,
  });

  final List<Notification> messages;

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;
    final messageController = MessageController(
      vehicleRepository: VehicleRepositoryImpl(supabaseClient),
      vehicleCoordinatesRepository: VehicleCoordinatesRepositoryImpl(supabaseClient),
    );

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
        children: messages.map((message) {
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
                  messageController.requestSupport(context, message.plateNumber!);
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
