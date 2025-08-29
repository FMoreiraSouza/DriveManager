import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';

class UpdateVehicleDefectStatusUsecase {
  final VehicleRepository _vehicleRepository;

  UpdateVehicleDefectStatusUsecase(this._vehicleRepository);

  Future<bool> execute(String plateNumber, bool hasDefect) async {
    return await _vehicleRepository.updateVehicleDefectStatus(plateNumber, hasDefect);
  }
}
