import 'package:drivemanager/data/repository/user_repository.dart';
import 'package:drivemanager/presenter/controllers/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepositoryImpl(GetStorage());
    final infoController = InfoController(userRepository);
    final userName = infoController.getUserName();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Usuário: $userName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Center(
              child: Image.asset(
                'assets/images/drive_manager_logo.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            const Align(
              child: Text(
                'Descrição:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            const Align(
              child: Text(
                'Gerenciador de frotas para Mobile',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
