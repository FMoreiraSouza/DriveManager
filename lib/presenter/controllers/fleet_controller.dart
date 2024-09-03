import 'package:supabase_flutter/supabase_flutter.dart';

class FleetController {
  final SupabaseClient _supabase; // Cliente Supabase para interagir com o banco de dados.
  final void Function() onFleetUpdated; // Callback chamado quando a lista de veículos é atualizada.
  final void Function()
      onCoordinatesUpdated; // Callback chamado quando a lista de coordenadas é atualizada.

  List<Map<String, dynamic>> fleetList = []; // Lista que armazena os veículos.
  List<Map<String, dynamic>> coordinatesList =
      []; // Lista que armazena as coordenadas dos veículos.
  bool isLoading = true; // Flag que indica se os dados estão sendo carregados.

  late final RealtimeChannel
      vehicleSubscription; // Canal de assinatura para atualizações de veículos.
  late final RealtimeChannel
      coordinatesSubscription; // Canal de assinatura para atualizações de coordenadas.

  FleetController({
    required SupabaseClient supabase,
    required this.onFleetUpdated,
    required this.onCoordinatesUpdated,
  }) : _supabase = supabase;

  // Busca a lista de veículos no banco de dados e atualiza a lista local.
  Future<void> fetchFleetList() async {
    isLoading = true;
    final response = await _supabase.from('vehicles').select();
    fleetList = List<Map<String, dynamic>>.from(response);
    isLoading = false;
    onFleetUpdated();
  }

  // Busca a lista de coordenadas no banco de dados e atualiza a lista local.
  Future<void> fetchCoordinatesList() async {
    final response = await _supabase.from('vehicle_coordinates').select();
    coordinatesList = List<Map<String, dynamic>>.from(response);
    onCoordinatesUpdated();
  }

  // Inscreve-se para atualizações em tempo real sobre a tabela de veículos.
  void subscribeToFleetUpdates() {
    vehicleSubscription = _supabase
        .channel('public:vehicles')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'vehicles',
            callback: (_) => fetchFleetList())
        .subscribe();
  }

  // Inscreve-se para atualizações em tempo real sobre a tabela de coordenadas de veículos.
  void subscribeToCoordinatesUpdates() {
    coordinatesSubscription = _supabase
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'vehicle_coordinates',
            callback: (_) => fetchCoordinatesList())
        .subscribe();
  }

  // Cancela as assinaturas quando o controlador não for mais necessário.
  void dispose() {
    vehicleSubscription.unsubscribe();
    coordinatesSubscription.unsubscribe();
  }
}
