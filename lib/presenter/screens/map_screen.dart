import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Tela para exibir o mapa e os veículos
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController; // Controlador do Google Map
  bool _mapLoaded = false; // Indica se o mapa foi carregado
  bool _errorLoadingMap = false; // Indica se houve um erro ao carregar o mapa

  final LatLng _initialPosition = const LatLng(-5.1619, -38.1190); // Posição inicial do mapa
  final Set<Marker> _markers = {}; // Conjunto de marcadores no mapa
  late final SupabaseClient _supabase; // Cliente Supabase
  late final RealtimeChannel _vehicleCoordinatesChannel; // Canal para atualizações em tempo real

  @override
  void initState() {
    super.initState();
    _initializeSupabase(); // Inicializa o Supabase e carrega os dados
    _loadMap(); // Carrega o mapa
  }

  // Inicializa o Supabase e configura os canais de dados
  Future<void> _initializeSupabase() async {
    _supabase = Supabase.instance.client;
    await _subscribeToVehicleCoordinates(); // Assina atualizações de coordenadas dos veículos
    await _loadMarkersFromDatabase(); // Carrega os marcadores do banco de dados
  }

  // Carrega o mapa e define o estado de carregamento
  Future<void> _loadMap() async {
    try {
      setState(() {
        _errorLoadingMap = false;
      });
      await Future.delayed(const Duration(seconds: 2)); // Simula o carregamento do mapa
      if (mounted) {
        setState(() {
          _mapLoaded = true; // Atualiza o estado para mapa carregado
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorLoadingMap = true; // Atualiza o estado para erro de carregamento
        });
      }
    }
  }

  // Assina o canal para receber atualizações das coordenadas dos veículos
  Future<void> _subscribeToVehicleCoordinates() async {
    _vehicleCoordinatesChannel = _supabase
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'vehicle_coordinates',
          callback: (payload) {
            if (mounted) {
              final record = payload.newRecord;
              _updateMarkerPosition(record); // Atualiza a posição do marcador
            }
          },
        )
        .subscribe();
  }

  // Carrega os marcadores do banco de dados
  Future<void> _loadMarkersFromDatabase() async {
    final response = await _supabase.from('vehicle_coordinates').select();
    final data = response as List<dynamic>;

    if (mounted) {
      setState(() {
        _markers.clear(); // Limpa os marcadores existentes
        for (var record in data) {
          if (record is Map<String, dynamic>) {
            _updateMarkerPosition(record); // Atualiza a posição do marcador com os dados carregados
          } else {
            throw Exception('Formato de registro inesperado: $record');
          }
        }
      });
    }
  }

  // Atualiza a posição de um marcador com base nos dados fornecidos
  Future<void> _updateMarkerPosition(Map<String, dynamic> record) async {
    final imeiNumber = record['imei'] as int?;
    final lat = record['latitude'] as double?;
    final lng = record['longitude'] as double?;

    if (imeiNumber != null && lat != null && lng != null) {
      final imei = imeiNumber.toString();
      final icon = await _getMarkerIcon(imei); // Obtém o ícone do marcador

      if (mounted) {
        setState(() {
          _markers
              .removeWhere((marker) => marker.markerId.value == imei); // Remove marcador existente
          _markers.add(
            Marker(
              markerId: MarkerId(imei),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(title: imei),
              icon: icon,
            ),
          );
        });
      }
    } else {
      throw Exception('Formato de registro inesperado: $record');
    }
  }

  // Obtém o ícone do marcador
  Future<BitmapDescriptor> _getMarkerIcon(String imei) async {
    const iconPath = 'assets/icons/marker.png';
    return BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      iconPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_mapLoaded)
            GoogleMap(
              onMapCreated: (controller) {
                mapController = controller; // Inicializa o controlador do mapa
              },
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 10,
              ),
              markers: _markers,
            )
          else if (_errorLoadingMap)
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
    _vehicleCoordinatesChannel.unsubscribe(); // Cancela a assinatura ao descartar o widget
    super.dispose();
  }
}
