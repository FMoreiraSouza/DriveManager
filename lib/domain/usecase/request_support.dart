import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';
import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';

class RequestSupport {
  final VehicleRepository _vehicleRepository;
  final VehicleCoordinatesRepository _vehicleCoordinatesRepository;

  RequestSupport(this._vehicleRepository, this._vehicleCoordinatesRepository);

  Future<bool> execute(String plateNumber) async {
    try {
      final vehicles = await _vehicleRepository.fetchVehicles();
      final vehicle = vehicles.firstWhere((v) => v.plateNumber == plateNumber);
      if (vehicle.imei == null) {
        throw Exception('Veículo com placa $plateNumber não encontrado ou IMEI inválido.');
      }
      await _vehicleCoordinatesRepository.updateVehicleStatus(vehicle.imei!, false);
      return true;
    } catch (e) {
      throw Exception('Erro ao solicitar suporte: $e');
    }
  }
}
