import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';
import 'package:drivemanager/domain/usecase/update_vehicle_status_usecase.dart';

class MessageController {
  final UpdateVehicleDefectStatusUsecase _updateDefectStatusUsecase;

  MessageController({
    required VehicleRepository vehicleRepository,
  }) : _updateDefectStatusUsecase = UpdateVehicleDefectStatusUsecase(vehicleRepository);

  Future<void> handleSupportRequest(String plateNumber) async {
    final success = await _updateDefectStatusUsecase.execute(plateNumber, false);

    if (!success) {
      throw Exception('Não foi possível atualizar o status de defeito');
    }
  }
}
