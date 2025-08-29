import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';

class FetchCoordinatesListUsecase {
  final VehicleCoordinatesRepository _vehicleCoordinatesRepository;

  FetchCoordinatesListUsecase(this._vehicleCoordinatesRepository);

  Future<List<VehicleCoordinates>> execute() async {
    return await _vehicleCoordinatesRepository.fetchCoordinates();
  }
}
