import 'package:drivemanager/data/model/vehicle.dart';
import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';

class RegisterVehicleUsecase {
  final VehicleRepository _vehicleRepository;

  RegisterVehicleUsecase(this._vehicleRepository);

  Future<void> execute({
    required String plateNumber,
    required String brand,
    required String model,
    required double mileage,
    required String imei, // Alterado para String
  }) async {
    final vehicle = Vehicle(
      id: 0,
      plateNumber: plateNumber,
      brand: brand,
      model: model,
      mileage: mileage,
      imei: imei, // Agora é String
    );

    await _vehicleRepository.insertVehicle(vehicle);

    if (imei.isNotEmpty) {
      // Verificar se não está vazio em vez de null
      await _vehicleRepository.insertVehicleCoordinate(imei);
    }
  }
}
