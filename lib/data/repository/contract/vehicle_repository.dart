import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/data/model/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> fetchVehicles();
  Future<void> insertVehicle(Vehicle vehicle);
  Future<void> insertVehicleCoordinate(String imei);
  Future<bool> updateVehicleDefectStatus(String plateNumber, bool hasDefect);
  RealtimeChannel subscribeToUpdates(void Function() callback);
}
