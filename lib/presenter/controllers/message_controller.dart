import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';
import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';
import 'package:drivemanager/domain/usecase/request_support_usecase.dart';

class MessageController {
  final RequestSupportUsecase _requestSupport;

  MessageController({
    required VehicleRepository vehicleRepository,
    required VehicleCoordinatesRepository vehicleCoordinatesRepository,
  }) : _requestSupport = RequestSupportUsecase(vehicleRepository, vehicleCoordinatesRepository);

  Future<bool> requestSupport(String plateNumber) async {
    try {
      final success = await _requestSupport.execute(plateNumber);
      return success;
    } catch (e) {
      throw Exception('Erro ao solicitar suporte: $e');
    }
  }
}
