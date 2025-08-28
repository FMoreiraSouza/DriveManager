import 'package:drivemanager/data/repository/auth_repository_impl.dart';
import 'package:drivemanager/data/repository/notification_repository_impl.dart';
import 'package:drivemanager/presenter/controllers/home_controller.dart';
import 'package:drivemanager/view/screens/message_screen.dart';
import 'package:drivemanager/core/themes/app_theme.dart';
import 'package:drivemanager/core/utils/load_panel.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late HomeController _homeController;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _homeController = HomeController(
      notificationRepository: NotificationRepositoryImpl(supabase),
      authRepository: AuthRepositoryImpl(supabase),
      onLogoutStatusChanged: _handleLogoutStatusChanged,
    );
    _homeController.fetchMessages().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
    _homeController.subscribeNotifications(_handleNotification);
  }

  void _handleLogoutStatusChanged(bool isLoggingOut) {
    if (mounted) {
      setState(() {
        _isLoggingOut = isLoggingOut;
      });
    }
  }

  void _handleNotification(String message) {
    if (mounted) {
      _showSnackBar(message);
    }
  }

  @override
  void dispose() {
    _homeController.unsubscribeNotifications();
    super.dispose();
  }

  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final snackBar = SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey.shade200,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Fechar',
            textColor: Colors.black,
            onPressed: () {
              scaffoldMessenger.hideCurrentSnackBar();
            },
          ),
        );
        scaffoldMessenger.showSnackBar(snackBar);
      }
    });
  }

  Future<void> _handleMenuSelection(String result) async {
    await _homeController.handleMenuSelection(result);
    if (result == 'sair' && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    switch (_homeController.selectedIndex) {
      case 0:
        appBarTitle = 'Frotas registradas';
        break;
      case 1:
        appBarTitle = 'Mapa';
        break;
      default:
        appBarTitle = 'Frotas registradas';
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageScreen(
                      messages: _homeController.messages,
                    ),
                  ),
                );
              },
            ),
            Center(child: Text(appBarTitle)),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'info',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Informativo'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sair',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          _homeController.pages[_homeController.selectedIndex],
          if (_isLoggingOut)
            const LoadPanel(
              label: 'Saindo...',
              bgColor: Colors.black54,
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _homeController.selectedIndex,
        onTap: (index) {
          setState(() {
            _homeController.selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Frotas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
        ],
        selectedItemColor: AppTheme.theme.hintColor,
      ),
    );
  }
}
