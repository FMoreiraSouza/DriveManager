import 'package:drivemanager/data/model/vehicle.dart';
import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';

class FetchFleetList {
  final VehicleRepository _vehicleRepository;

  FetchFleetList(this._vehicleRepository);

  Future<List<Vehicle>> execute() async {
    return await _vehicleRepository.fetchVehicles();
  }
}
