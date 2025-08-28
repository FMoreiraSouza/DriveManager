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
            // CORREÇÃO: Use operador null-aware e forneça valor padrão
            final message = payload.newRecord['message']?.toString() ?? '';

            // Só chama se a mensagem não for vazia
            if (message.isNotEmpty) {
              onMessageReceived(message);
            }

            _notificationRepository.fetchNotifications();
          },
        )
        .subscribe();
  }
}
