import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:flutter/material.dart';

class EmptyFleet extends StatelessWidget {
  const EmptyFleet({super.key, required this.onClick});

  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sem frota cadastrada',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18),
        ),
        GestureDetector(
          onTap: () {
            onClick;
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              onTap: () {
                NavigationService.pushNamed('/fleet-register');
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Comece já!',
                    textAlign: TextAlign.center,
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
        const SizedBox(
          height: 16.0,
        ),
        Image.asset('assets/images/register_your_fleet.png'),
      ],
    );
  }
}
