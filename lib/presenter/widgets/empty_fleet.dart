import 'package:flutter/material.dart';

class EmptyFleet extends StatelessWidget {
  const EmptyFleet({super.key, required this.onClick});

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sem frota cadastrada',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 18,
          ),
        ),
        GestureDetector(
          onTap: onClick,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClick,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.green),
                  SizedBox(width: 8.0),
                  Text(
                    'Comece já!',
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
        Image.asset('assets/images/register_your_fleet.png'),
      ],
    );
  }
}
