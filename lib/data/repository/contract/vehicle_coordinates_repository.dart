import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/data/model/vehicle_coodinates.dart';

abstract class VehicleCoordinatesRepository {
  Future<List<VehicleCoordinates>> fetchCoordinates();
  Future<bool> updateVehicleStatus(String imei, bool isStopped); // Mudou para Future<bool>
  RealtimeChannel subscribeToUpdates(void Function() callback);
}
