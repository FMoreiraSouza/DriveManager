import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Tela para exibir uma lista de mensagens
class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    this.messages,
  });

  // Lista de mensagens a ser exibida
  final List<Map<String, dynamic>>? messages;

  @override
  Widget build(BuildContext context) {
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
                _showSupportDialog(context, message['plate_number']);
              },
              child: const Text('Solicitar Suporte'),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Exibe um diálogo para solicitar suporte
  Future<void> _showSupportDialog(BuildContext context, String plateNumber) async {
    final SupabaseClient supabaseClient = Supabase.instance.client;

    // Consulta para obter o IMEI do veículo
    final response = await supabaseClient
        .from('vehicles')
        .select('imei')
        .eq('plate_number', plateNumber)
        .single();

    final imei = response['imei'];

    // Atualiza o status do veículo
    final updateResponse = await supabaseClient
        .from('vehicle_coordinates')
        .update({'isStopped': false}).eq('imei', imei);

    if (updateResponse == null) {
      // Exibe mensagem de sucesso
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Solicitação de Suporte para $plateNumber'),
            content: const Row(
              children: [
                Icon(Icons.check, color: Colors.green),
                SizedBox(width: 8),
                Expanded(child: Text('Suporte enviado com sucesso!')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      // Exibe mensagem de erro
      // ignore: use_build_context_synchronously
      showErrorDialog(context, plateNumber);
    }
  }

  // Exibe um diálogo de erro
  void showErrorDialog(BuildContext context, String plateNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro ao solicitar suporte para $plateNumber'),
          content: const Text('Ocorreu um erro ao tentar enviar a solicitação de suporte.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
