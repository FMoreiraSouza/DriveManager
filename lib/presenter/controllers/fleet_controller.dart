import 'package:drivemanager/data/model/vehicle.dart';
import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FleetController {
  final SupabaseClient _supabase;
  final void Function() onFleetUpdated;
  final void Function() onCoordinatesUpdated;

  List<Vehicle> fleetList = [];
  List<VehicleCoordinates> coordinatesList = [];
  bool isLoading = true;

  late final RealtimeChannel vehicleSubscription;
  late final RealtimeChannel coordinatesSubscription;

  FleetController({
    required SupabaseClient supabase,
    required this.onFleetUpdated,
    required this.onCoordinatesUpdated,
  }) : _supabase = supabase;

  Future<void> fetchFleetList() async {
    isLoading = true;
    try {
      final response = await _supabase.from('vehicles').select();
      fleetList = (response as List<dynamic>)
          .map((item) => Vehicle.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      print('Erro ao buscar lista de veículos: $e');
      throw Exception('Erro ao buscar lista de veículos: $e');
    } finally {
      isLoading = false;
      onFleetUpdated();
    }
  }

  Future<void> fetchCoordinatesList() async {
    try {
      final response = await _supabase.from('vehicle_coordinates').select();
      coordinatesList = (response as List<dynamic>)
          .map((item) => VehicleCoordinates.fromMap(Map<String, dynamic>.from(item)))
          .toList();
      onCoordinatesUpdated();
    } catch (e) {
      print('Erro ao buscar coordenadas: $e');
      throw Exception('Erro ao buscar coordenadas: $e');
    }
  }

  void subscribeToFleetUpdates() {
    vehicleSubscription = _supabase
        .channel('public:vehicles')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'vehicles',
          callback: (_) => fetchFleetList(),
        )
        .subscribe();
  }

  void subscribeToCoordinatesUpdates() {
    coordinatesSubscription = _supabase
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'vehicle_coordinates',
          callback: (_) => fetchCoordinatesList(),
        )
        .subscribe();
  }

  void dispose() {
    vehicleSubscription.unsubscribe();
    coordinatesSubscription.unsubscribe();
  }
}
