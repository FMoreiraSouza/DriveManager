import 'package:drivemanager/data/model/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> fetchNotifications();
}
