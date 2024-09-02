// Importa pacotes necessários para o widget InfoScreen.
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

// Define o widget InfoScreen como um StatelessWidget.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém uma instância do GetStorage para acessar dados armazenados localmente.
    final box = GetStorage();
    // Lê o nome do usuário do armazenamento local, com um valor padrão se não estiver disponível.
    final userName = box.read('user_name') ?? 'Usuário não disponível';

    return Scaffold(
      // Cria a estrutura básica da tela com um AppBar e um corpo.
      appBar: AppBar(
        title: const Text('Informações do Usuário'),
      ),
      body: Padding(
        // Adiciona um padding ao redor do corpo da tela.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibe o nome do usuário centralizado no topo.
            Center(
              child: Text(
                'Usuário: $userName',
                style: const TextStyle(
                  fontSize: 18, // Tamanho da fonte.
                  fontWeight: FontWeight.bold, // Peso da fonte.
                ),
              ),
            ),
            // Adiciona um espaçamento entre os widgets.
            const SizedBox(height: 8.0),
            // Exibe a imagem do logo do drive manager centralizada.
            Center(
              child: Image.asset(
                'assets/images/drive_manager_logo.png',
                width: 100, // Largura da imagem.
                height: 100, // Altura da imagem.
                fit: BoxFit.cover, // Ajusta o tamanho da imagem para cobrir o espaço disponível.
              ),
            ),
            // Adiciona um espaçamento entre os widgets.
            const SizedBox(height: 16.0),
            // Exibe o título "Descrição:" alinhado à esquerda.
            const Align(
              child: Text(
                'Descrição:',
                style: TextStyle(
                  fontSize: 20, // Tamanho da fonte.
                  fontWeight: FontWeight.w600, // Peso da fonte.
                ),
              ),
            ),
            // Adiciona um espaçamento entre os widgets.
            const SizedBox(height: 4.0),
            // Exibe a descrição do aplicativo alinhada à esquerda.
            const Align(
              child: Text(
                'Gerenciador de frotas para Mobile',
                style: TextStyle(
                  fontSize: 16, // Tamanho da fonte.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
