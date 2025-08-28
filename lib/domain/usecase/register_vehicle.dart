import 'package:drivemanager/data/model/vehicle.dart';
import 'package:drivemanager/data/repository/vehicle_repository.dart';

class RegisterVehicle {
  final VehicleRepository _vehicleRepository;

  RegisterVehicle(this._vehicleRepository);

  Future<void> execute({
    required String plateNumber,
    required String brand,
    required String model,
    required double mileage,
    required int? imei,
  }) async {
    final vehicle = Vehicle(
      id: 0,
      plateNumber: plateNumber,
      brand: brand,
      model: model,
      mileage: mileage,
      imei: imei,
    );
    await _vehicleRepository.insertVehicle(vehicle);
  }
}
