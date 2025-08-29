import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';

class VehicleCoordinatesRepositoryImpl implements VehicleCoordinatesRepository {
  final SupabaseClient _supabase;

  VehicleCoordinatesRepositoryImpl(this._supabase);

  @override
  Future<List<VehicleCoordinates>> fetchCoordinates() async {
    try {
      final response = await _supabase.from('vehicle_coordinates').select();
      return (response as List<dynamic>)
          .map((item) => VehicleCoordinates.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar coordenadas: $e');
    }
  }

  @override
  Future<bool> updateVehicleStatus(String imei, bool isStopped) async {
    try {
      final response = await _supabase
          .from('vehicle_coordinates')
          .update({'isStopped': isStopped}).eq('imei', imei);

      return response != null;
    } catch (e) {
      throw Exception('Erro ao atualizar status do veículo: $e');
    }
  }

  @override
  RealtimeChannel subscribeToUpdates(void Function() callback) {
    return _supabase
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'vehicle_coordinates',
          callback: (payload) {
            callback();
          },
        )
        .subscribe();
  }
}
