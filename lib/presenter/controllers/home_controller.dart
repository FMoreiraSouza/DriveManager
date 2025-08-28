import 'package:drivemanager/data/model/notification.dart';
import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:drivemanager/presenter/screens/fleet_screen.dart';
import 'package:drivemanager/presenter/screens/map_screen.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LoginController loginController;
  final Function(bool) onLogoutStatusChanged;

  bool isLoggingOut = false;
  int selectedIndex = 0;
  List<Notification> messages = [];
  late final RealtimeChannel _notificationChannel;

  final List<Widget> pages = [
    const FleetScreen(),
    const MapScreen(),
  ];

  HomeController(this.loginController, this.onLogoutStatusChanged);

  Future<void> fetchMessages() async {
    try {
      final response = await _supabase.from('notifications').select();
      messages = (response as List<dynamic>)
          .map((item) => Notification.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      print('Erro ao buscar mensagens: $e');
      throw Exception('Erro ao buscar mensagens: $e');
    }
  }

  Future<void> subscribeNotifications(Function(String) onMessageReceived) async {
    _notificationChannel = _supabase
        .channel('public:notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          callback: (payload) {
            final message = payload.newRecord['message'] as String;
            onMessageReceived(message);
            fetchMessages();
          },
        )
        .subscribe();
  }

  void unsubscribeNotifications() {
    _notificationChannel.unsubscribe();
  }

  Future<void> handleMenuSelection(String result) async {
    switch (result) {
      case 'info':
        NavigationService.pushNamed('/info');
        break;
      case 'sair':
        isLoggingOut = true;
        onLogoutStatusChanged(isLoggingOut);
        await loginController.signOut();
        await Future.delayed(const Duration(seconds: 2));
        isLoggingOut = false;
        onLogoutStatusChanged(isLoggingOut);
        break;
    }
  }
}
