import 'package:drivemanager/data/model/vehicle.dart';
import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';

class FetchFleetListUsecase {
  final VehicleRepository _vehicleRepository;

  FetchFleetListUsecase(this._vehicleRepository);

  Future<List<Vehicle>> execute() async {
    return await _vehicleRepository.fetchVehicles();
  }
}
