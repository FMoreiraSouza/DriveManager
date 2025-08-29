import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';
import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';
import 'package:drivemanager/data/repository/contract/notification_repository.dart';

class MessageController {
  MessageController({
    required VehicleRepository vehicleRepository,
    required VehicleCoordinatesRepository vehicleCoordinatesRepository,
    required NotificationRepository notificationRepository,
  });
}
