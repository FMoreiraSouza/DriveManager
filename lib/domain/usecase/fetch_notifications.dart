import 'package:drivemanager/data/model/notification.dart';
import 'package:drivemanager/data/repository/contract/notification_repository.dart';

class FetchNotifications {
  final NotificationRepository _notificationRepository;

  FetchNotifications(this._notificationRepository);

  Future<List<Notification>> execute() async {
    return await _notificationRepository.fetchNotifications();
  }
}
