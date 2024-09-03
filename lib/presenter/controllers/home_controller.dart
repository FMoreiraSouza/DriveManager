import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:drivemanager/presenter/screens/fleet_screen.dart';
import 'package:drivemanager/presenter/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LoginController loginController;

  HomeController(this.loginController, this.onLogoutStatusChanged);

  bool isLoggingOut = false;
  int selectedIndex = 0;
  List<Map<String, dynamic>> messages = [];
  late final RealtimeChannel _notificationChannel;
  final Function(bool) onLogoutStatusChanged;

  final List<Widget> pages = [
    const FleetScreen(),
    const MapScreen(),
  ];

  // Função assíncrona para buscar mensagens da tabela 'notifications'.
  Future<void> fetchMessages() async {
    final response = await _supabase.from('notifications').select();
    messages = List<Map<String, dynamic>>.from(response);
  }

  // Função assíncrona para assinar o canal de notificações e receber atualizações.
  Future<void> subscribeNotifications(Function(String) onMessageReceived) async {
    _notificationChannel = _supabase
        .channel('public:notifications')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'notifications',
            callback: (payload) {
              final message = payload.newRecord['message'];
              onMessageReceived(message); // Passa a mensagem para o callback
              fetchMessages();
            })
        .subscribe();
  }

  // Função para cancelar a assinatura do canal de notificações.
  void unsubscribeNotifications() {
    _notificationChannel.unsubscribe();
  }

  // Função para lidar com a seleção do menu suspenso na AppBar.
  Future<void> handleMenuSelection(String result) async {
    switch (result) {
      case 'info':
        NavigationService.pushNamed('/info');
        break;
      case 'sair':
        isLoggingOut = true;
        onLogoutStatusChanged(isLoggingOut); // Notifica a HomeScreen
        await loginController.signOut();
        await Future.delayed(const Duration(seconds: 2));
        isLoggingOut = false;
        onLogoutStatusChanged(isLoggingOut); // Notifica a HomeScreen
        break;
    }
  }
}
