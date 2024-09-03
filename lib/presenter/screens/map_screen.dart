import 'package:drivemanager/presenter/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(); // Inicializa o controlador do mapa
    _mapController.initializeSupabase(); // Inicializa o Supabase
    _mapController.loadMap(
      (mapLoaded) => setState(() {}), // Atualiza o estado quando o mapa é carregado
      (errorLoadingMap) => setState(() {}), // Atualiza o estado se houver erro ao carregar o mapa
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_mapController.mapLoaded)
            GoogleMap(
              onMapCreated: (controller) {
                _mapController.mapController = controller; // Define o controlador do mapa
              },
              initialCameraPosition: CameraPosition(
                target: _mapController.initialPosition,
                zoom: 10,
              ),
              markers: _mapController.markers, // Marca as localizações no mapa
            )
          else if (_mapController.errorLoadingMap)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não foi possível acessar o mapa, verifique a sua conexão!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                    Image.asset('assets/images/unload_map.png'),
                  ],
                ),
              ),
            )
          else
            const Center(
                child:
                    CircularProgressIndicator()), // Exibe indicador de progresso enquanto carrega o mapa
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose(); // Libera recursos quando a tela é descartada
    super.dispose();
  }
}
