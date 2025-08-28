import 'package:drivemanager/data/repository/vehicle_coordinates_repository.dart';
import 'package:drivemanager/data/repository/vehicle_repository.dart';
import 'package:drivemanager/domain/usecase/request_support.dart';

class MessageController {
  final RequestSupport _requestSupport;

  MessageController({
    required VehicleRepository vehicleRepository,
    required VehicleCoordinatesRepository vehicleCoordinatesRepository,
  }) : _requestSupport = RequestSupport(vehicleRepository, vehicleCoordinatesRepository);

  Future<bool> requestSupport(String plateNumber) async {
    try {
      final success = await _requestSupport.execute(plateNumber);
      return success;
    } catch (e) {
      throw Exception('Erro ao solicitar suporte: $e');
    }
  }
}
