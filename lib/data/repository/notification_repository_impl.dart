import 'package:drivemanager/data/model/notification.dart';
import 'package:drivemanager/data/repository/contract/notification_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  Future<void> deleteNotificationsByPlateNumber(String plateNumber) async {
    try {
      await _supabase.from('notifications').delete().eq('plate_number', plateNumber);
    } catch (e) {
      throw Exception('Erro ao excluir notificações: $e');
    }
  }

  @override
  Future<void> deleteNotificationById(String id) async {
    try {
      await _supabase.from('notifications').delete().eq('id', id);
    } catch (e) {
      throw Exception('Erro ao excluir notificação: $e');
    }
  }
}
