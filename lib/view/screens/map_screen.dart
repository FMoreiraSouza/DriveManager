import 'package:drivemanager/data/repository/vehicle_coordinates_repository_impl.dart';
import 'package:drivemanager/presenter/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final supabase = Supabase.instance.client;
    _mapController = MapController(
      vehicleCoordinatesRepository: VehicleCoordinatesRepositoryImpl(supabase),
      supabase: supabase,
    );
    _mapController.initializeSupabase();
    _mapController.loadMap(
      (mapLoaded) => setState(() {}),
      (errorLoadingMap) => setState(() {}),
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
                _mapController.mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _mapController.initialPosition,
                zoom: 10,
              ),
              markers: _mapController.markers,
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
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
