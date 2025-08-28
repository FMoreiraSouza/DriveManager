import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';
import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';
import 'package:drivemanager/data/repository/contract/notification_repository.dart';

class RequestSupportUsecase {
  final VehicleRepository _vehicleRepository;
  final VehicleCoordinatesRepository _vehicleCoordinatesRepository;
  final NotificationRepository _notificationRepository;

  RequestSupportUsecase(
    this._vehicleRepository,
    this._vehicleCoordinatesRepository,
    this._notificationRepository,
  );

  Future<bool> execute(String plateNumber) async {
    try {
      // Buscar veículo pelo plateNumber
      final vehicles = await _vehicleRepository.fetchVehicles();
      final vehicle = vehicles.firstWhere((v) => v.plateNumber == plateNumber);

      // Atualizar status do veículo
      await _vehicleCoordinatesRepository.updateVehicleStatus(vehicle.imei, false);

      // Excluir todas as notificações com o mesmo plateNumber
      await _notificationRepository.deleteNotificationsByPlateNumber(plateNumber);

      return true;
    } catch (e) {
      throw Exception('Erro ao solicitar suporte: $e');
    }
  }
}
