import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class VehicleCoordinatesRepository {
  Future<List<VehicleCoordinates>> fetchCoordinates();
  Future<void> updateVehicleStatus(int imei, bool isStopped);
}

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
  Future<void> updateVehicleStatus(int imei, bool isStopped) async {
    try {
      await _supabase.from('vehicle_coordinates').update({'isStopped': isStopped}).eq('imei', imei);
    } catch (e) {
      throw Exception('Erro ao atualizar status do veículo: $e');
    }
  }
}
