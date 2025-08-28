import 'package:drivemanager/data/model/vehicle_coodinates.dart';

abstract class VehicleCoordinatesRepository {
  Future<List<VehicleCoordinates>> fetchCoordinates();
  Future<void> updateVehicleStatus(int imei, bool isStopped);
}
