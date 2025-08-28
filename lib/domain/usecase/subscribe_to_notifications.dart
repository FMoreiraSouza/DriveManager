import 'package:drivemanager/data/repository/contract/notification_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscribeToNotifications {
  final NotificationRepository _notificationRepository;

  SubscribeToNotifications(this._notificationRepository);

  RealtimeChannel execute(void Function(String) onMessageReceived) {
    return Supabase.instance.client
        .channel('public:notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          callback: (payload) {
            final message = payload.newRecord['message'] as String;
            onMessageReceived(message);
            _notificationRepository.fetchNotifications();
          },
        )
        .subscribe();
  }
}
