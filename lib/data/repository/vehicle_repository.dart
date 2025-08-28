import 'package:drivemanager/data/model/vehicle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> fetchVehicles();
  Future<void> insertVehicle(Vehicle vehicle);
}

class VehicleRepositoryImpl implements VehicleRepository {
  final SupabaseClient _supabase;

  VehicleRepositoryImpl(this._supabase);

  @override
  Future<List<Vehicle>> fetchVehicles() async {
    try {
      final response = await _supabase.from('vehicles').select();
      return (response as List<dynamic>)
          .map((item) => Vehicle.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar lista de veículos: $e');
    }
  }

  @override
  Future<void> insertVehicle(Vehicle vehicle) async {
    try {
      await _supabase.from('vehicles').insert({
        'plate_number': vehicle.plateNumber,
        'brand': vehicle.brand,
        'model': vehicle.model,
        'mileage': vehicle.mileage,
        'imei': vehicle.imei,
      });
    } catch (e) {
      throw Exception('Erro ao salvar veículo: $e');
    }
  }
}
