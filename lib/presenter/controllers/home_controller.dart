import 'package:drivemanager/data/model/notification.dart';
import 'package:drivemanager/data/repository/contract/auth_repository.dart';
import 'package:drivemanager/data/repository/contract/notification_repository.dart';
import 'package:drivemanager/domain/usecase/fetch_notifications_usecase.dart';
import 'package:drivemanager/domain/usecase/handle_menu_selection_usecase.dart';
import 'package:drivemanager/domain/usecase/subscribe_to_notifications_usecase.dart';
import 'package:drivemanager/view/screens/fleet_screen.dart';
import 'package:drivemanager/view/screens/map_screen.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController {
  final FetchNotificationsUsecase _fetchNotifications;
  final SubscribeToNotificationsUsecase _subscribeToNotifications;
  final HandleMenuSelectionUsecase _handleMenuSelection;
  final Function(bool) onLogoutStatusChanged;

  bool isLoggingOut = false;
  int selectedIndex = 0;
  List<Notification> messages = [];
  late final RealtimeChannel _notificationChannel;

  final List<Widget> pages = [
    const FleetScreen(),
    const MapScreen(),
  ];

  HomeController({
    required NotificationRepository notificationRepository,
    required AuthRepository authRepository,
    required this.onLogoutStatusChanged,
  })  : _fetchNotifications = FetchNotificationsUsecase(notificationRepository),
        _subscribeToNotifications = SubscribeToNotificationsUsecase(notificationRepository),
        _handleMenuSelection = HandleMenuSelectionUsecase(authRepository);

  Future<void> fetchMessages() async {
    try {
      messages = await _fetchNotifications.execute();
    } catch (e) {
      throw Exception('Erro ao buscar mensagens: $e');
    }
  }

  Future<void> subscribeNotifications(Function(String) onMessageReceived) async {
    _notificationChannel = _subscribeToNotifications.execute(onMessageReceived);
  }

  void unsubscribeNotifications() {
    _notificationChannel.unsubscribe();
  }

  Future<void> handleMenuSelection(String result) async {
    isLoggingOut = true;
    onLogoutStatusChanged(isLoggingOut);
    try {
      await _handleMenuSelection.execute(result);
    } catch (e) {
      throw Exception('Erro ao processar seleção do menu: $e');
    } finally {
      isLoggingOut = false;
      onLogoutStatusChanged(isLoggingOut);
    }
  }
}
