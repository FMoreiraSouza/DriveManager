// Importa pacotes e widgets necessários para a tela de frotas.
import 'package:drivemanager/presenter/widgets/empty_fleet.dart';
import 'package:drivemanager/presenter/widgets/fleet_list.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Define a tela que exibe a lista de frotas.
class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

// Estado da tela de frotas.
class _FleetScreenState extends State<FleetScreen> {
  // Lista de veículos e coordenadas do veículo.
  List<Map<String, dynamic>> _fleetList = [];
  List<Map<String, dynamic>> _coordinatesList = [];

  // Cliente Supabase para interagir com o banco de dados.
  final SupabaseClient _supabase = Supabase.instance.client;

  // Canais de assinatura para atualizações em tempo real.
  late final RealtimeChannel _vehicleSubscription;
  late final RealtimeChannel _coordinatesSubscription;

  // Flag para indicar se os dados estão carregando.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Inicializa a tela buscando a lista de frotas e coordenadas,
    // e assinando atualizações em tempo real.
    _fetchFleetList();
    _fetchCoordinatesList();
    _subscribeToFleetUpdates();
    _subscribeToCoordinatesUpdates();
  }

  // Função assíncrona para buscar a lista de frotas da tabela 'vehicles'.
  Future<void> _fetchFleetList() async {
    setState(() {
      _isLoading = true; // Inicia o carregamento.
    });
    final response = await _supabase.from('vehicles').select();

    setState(() {
      _fleetList = List<Map<String, dynamic>>.from(response);
      _isLoading = false; // Finaliza o carregamento.
    });
  }

  // Função assíncrona para buscar a lista de coordenadas da tabela 'vehicle_coordinates'.
  Future<void> _fetchCoordinatesList() async {
    final response = await _supabase.from('vehicle_coordinates').select();
    setState(() {
      _coordinatesList = List<Map<String, dynamic>>.from(response);
    });
  }

  // Função para assinar atualizações em tempo real para a tabela 'vehicles'.
  void _subscribeToFleetUpdates() {
    _vehicleSubscription = _supabase
        .channel('public:vehicles')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'vehicles',
            callback: (payload) {
              _fetchFleetList(); // Atualiza a lista de frotas quando há mudanças.
            })
        .subscribe();
  }

  // Função para assinar atualizações em tempo real para a tabela 'vehicle_coordinates'.
  void _subscribeToCoordinatesUpdates() {
    _coordinatesSubscription = _supabase
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'vehicle_coordinates',
            callback: (payload) {
              _fetchCoordinatesList(); // Atualiza a lista de coordenadas quando há mudanças.
            })
        .subscribe();
  }

  @override
  void dispose() {
    // Cancela as assinaturas ao descartar a tela.
    _vehicleSubscription.unsubscribe();
    _coordinatesSubscription.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Exibe o conteúdo centralizado com padding.
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _fleetList.isEmpty && !_isLoading
                // Se a lista de frotas estiver vazia e não estiver carregando,
                // exibe o widget EmptyFleet com um callback para abrir a tela de registro de frota.
                ? EmptyFleet(onClick: _openFleetRegisterScreen)
                : FleetList(
                    // Caso contrário, exibe o widget FleetList com a lista de frotas e coordenadas.
                    onButtonClick: _openFleetRegisterScreen,
                    fleetList: _fleetList,
                    coordinatesList: _coordinatesList,
                  ),
          ),
        ),
        // Exibe um indicador de carregamento se os dados estiverem carregando.
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  // Função para abrir a tela de registro de frota e atualizar a lista de frotas após o retorno.
  void _openFleetRegisterScreen() async {
    await Navigator.pushNamed(context, '/fleet-register');
    _fetchFleetList();
  }
}
