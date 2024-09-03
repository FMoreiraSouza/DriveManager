import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageController {
  final SupabaseClient supabaseClient;

  // Construtor que recebe o cliente Supabase
  MessageController(this.supabaseClient);

  // Função para solicitar suporte com base no número da placa
  Future<void> requestSupport(BuildContext context, String plateNumber) async {
    try {
      // Consulta para obter o IMEI do veículo
      final response = await supabaseClient
          .from('vehicles')
          .select('imei')
          .eq('plate_number', plateNumber)
          .single();

      final imei = response['imei'];

      // Atualiza o status do veículo para "não parado"
      final updateResponse = await supabaseClient
          .from('vehicle_coordinates')
          .update({'isStopped': false}).eq('imei', imei);

      if (updateResponse == null) {
        // Exibe mensagem de sucesso
        _showDialog(
          // ignore: use_build_context_synchronously
          context,
          'Solicitação de Suporte para $plateNumber',
          'Suporte enviado com sucesso!',
          Icons.check,
          Colors.green,
        );
      } else {
        // Exibe mensagem de erro
        _showDialog(
          // ignore: use_build_context_synchronously
          context,
          'Erro ao solicitar suporte para $plateNumber',
          'Ocorreu um erro ao tentar enviar a solicitação de suporte.',
          Icons.error,
          Colors.red,
        );
      }
    } catch (e) {
      // Exibe mensagem de erro em caso de exceção
      _showDialog(
        // ignore: use_build_context_synchronously
        context,
        'Erro',
        'Ocorreu um erro inesperado.',
        Icons.error,
        Colors.red,
      );
    }
  }

  // Função privada para exibir um diálogo com mensagem
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
