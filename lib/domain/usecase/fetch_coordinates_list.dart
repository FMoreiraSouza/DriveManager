import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';

class FetchCoordinatesList {
  final VehicleCoordinatesRepository _vehicleCoordinatesRepository;

  FetchCoordinatesList(this._vehicleCoordinatesRepository);

  Future<List<VehicleCoordinates>> execute() async {
    return await _vehicleCoordinatesRepository.fetchCoordinates();
  }
}
