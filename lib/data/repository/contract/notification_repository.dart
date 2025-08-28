import 'package:drivemanager/data/model/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> fetchNotifications();
  Future<void> deleteNotificationsByPlateNumber(String plateNumber);
  Future<void> deleteNotificationById(String id);
}
