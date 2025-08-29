import 'package:drivemanager/data/model/notification.dart';
import 'package:flutter/material.dart' hide Notification;

class MessageItemWidget extends StatelessWidget {
  final Notification message;
  final Function(String) onRequestSupport;

  const MessageItemWidget({
    super.key,
    required this.message,
    required this.onRequestSupport,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.settings,
        size: 40.0,
        color: Colors.green,
      ),
      title: Text(message.plateNumber ?? 'Sem placa'),
      subtitle: Text(message.message),
      trailing: TextButton(
        onPressed: () {
          if (message.plateNumber != null) {
            onRequestSupport(message.plateNumber!);
          }
        },
        child: const Text('Solicitar Suporte'),
      ),
    );
  }
}
