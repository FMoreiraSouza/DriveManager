import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:flutter/material.dart';

class EmptyFleet extends StatelessWidget {
  // Função a ser chamada quando o usuário interage com o widget.
  const EmptyFleet({super.key, required this.onClick});

  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sem frota cadastrada', // Mensagem informativa.
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 18,
          ),
        ),
        GestureDetector(
          onTap: () {
            onClick; // Ação a ser definida.
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                NavigationService.pushNamed(
                    '/fleet-register'); // Navega para a tela de registro de frota.
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.green), // Ícone de navegação.
                  SizedBox(width: 8.0),
                  Text(
                    'Comece já!', // Texto de incentivo.
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Image.asset('assets/images/register_your_fleet.png'), // Imagem ilustrativa.
      ],
    );
  }
}
