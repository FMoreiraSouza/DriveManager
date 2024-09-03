import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final String title;
  final String content;
  final Function() onClick;
  final VoidCallback onPressedOk;

  const CustomModal({
    super.key,
    required this.title,
    required this.content,
    required this.onPressedOk,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
          ),
          const SizedBox(height: 16.0),
          Text(content),
          const SizedBox(height: 16.0),
          const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              Icons.edit,
            ),
            Text('Editar frota')
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: onPressedOk,
                child: const Text('Ok'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
