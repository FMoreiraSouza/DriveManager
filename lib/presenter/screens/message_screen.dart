import 'package:drivemanager/presenter/controllers/message_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    this.messages, // Lista opcional de mensagens a ser exibida
  });

  final List<Map<String, dynamic>>? messages; // Lista de mensagens

  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabaseClient = Supabase.instance.client; // Obtém o cliente Supabase
    final MessageController messageController =
        MessageController(supabaseClient); // Inicializa o controlador de mensagens

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagens'), // Título da AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Botão de voltar
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      body: ListView(
        children: messages!.map((message) {
          // Cria um ListTile para cada mensagem
          return ListTile(
            leading: const Icon(
              Icons.settings,
              size: 40.0,
              color: Colors.green,
            ),
            title: Text(
              message['plate_number'] ?? 'Sem placa', // Número da placa
            ),
            subtitle: Text(
              message['message'] ?? 'Sem mensagem', // Mensagem
            ),
            trailing: TextButton(
              onPressed: () {
                // Solicita suporte quando o botão é pressionado
                messageController.requestSupport(context, message['plate_number']);
              },
              child: const Text('Solicitar Suporte'),
            ),
          );
        }).toList(),
      ),
    );
  }
}
