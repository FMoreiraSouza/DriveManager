import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FleetList extends StatelessWidget {
  const FleetList({
    super.key,
    this.onButtonClick,
    this.fleetList,
    this.coordinatesList,
  });

  final Function()? onButtonClick; // Função chamada ao clicar no botão flutuante.
  final List<Map<String, dynamic>>? fleetList; // Lista de veículos.
  final List<Map<String, dynamic>>? coordinatesList; // Lista de coordenadas dos veículos.

  @override
  Widget build(BuildContext context) {
    final NumberFormat mileageFormat =
        NumberFormat("#,##0.0", "pt_BR"); // Formato de quilometragem.

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ListView.builder(
            itemCount: fleetList?.length ?? 0, // Número de itens na lista.
            itemBuilder: (context, index) {
              final vehicle = fleetList?[index];
              final coordinates = (coordinatesList != null && coordinatesList!.length > index)
                  ? coordinatesList![index]
                  : {};
              final mileage = vehicle?['mileage'] ?? 0;
              final isStopped = coordinates['isStopped'] ?? false;
              final speed = coordinates['speed'] ?? 0.0;

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)), // Bordas arredondadas.
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_car), // Ícone de carro.
                          Expanded(
                            child: Text(
                              vehicle?['plate_number'] ?? 'Sem placa', // Número da placa.
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              color: isStopped ? Colors.red : Colors.green, // Indicador de status.
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.speed), // Ícone de velocidade.
                          Text('${mileageFormat.format(speed)} Km/h'), // Velocidade formatada.
                          const SizedBox(width: 15),
                          const Icon(Icons.emoji_transportation), // Ícone de transporte.
                          Text('${mileageFormat.format(mileage)} Km'), // Quilometragem formatada.
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: onButtonClick, // Função chamada ao clicar no botão flutuante.
            child: const Icon(Icons.add), // Ícone de adicionar.
          ),
        ),
      ],
    );
  }
}
