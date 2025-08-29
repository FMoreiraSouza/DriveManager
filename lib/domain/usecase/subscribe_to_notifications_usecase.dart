import 'package:drivemanager/data/repository/contract/notification_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscribeToNotificationsUsecase {
  final NotificationRepository _notificationRepository;

  SubscribeToNotificationsUsecase(this._notificationRepository);

  RealtimeChannel execute(void Function(String) onMessageReceived) {
    return Supabase.instance.client
        .channel('public:notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          callback: (payload) {
            final message = payload.newRecord['message']?.toString() ?? '';

            if (message.isNotEmpty) {
              onMessageReceived(message);
            }

            _notificationRepository.fetchNotifications();
          },
        )
        .subscribe();
  }
}
