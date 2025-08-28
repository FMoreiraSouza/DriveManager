import 'package:drivemanager/data/model/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> fetchVehicles();
  Future<void> insertVehicle(Vehicle vehicle);
}
