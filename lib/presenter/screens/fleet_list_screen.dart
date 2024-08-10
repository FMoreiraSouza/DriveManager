import 'package:flutter/material.dart';

class FleetListScreen extends StatelessWidget {
  const FleetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sem frota cadastrada? Comece ja!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18),
            ),
            Image.asset('assets/images/register_your_fleet.png'),
          ],
        ),
      ),
    );
  }
}
