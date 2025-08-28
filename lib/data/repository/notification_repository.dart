import 'package:drivemanager/data/model/notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NotificationRepository {
  Future<List<Notification>> fetchNotifications();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final SupabaseClient _supabase;

  NotificationRepositoryImpl(this._supabase);

  @override
  Future<List<Notification>> fetchNotifications() async {
    try {
      final response = await _supabase.from('notifications').select();
      return (response as List<dynamic>)
          .map((item) => Notification.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar notificações: $e');
    }
  }
}
