import 'package:flutter/material.dart';
import 'package:drivemanager/core/themes/app_theme.dart';
import 'package:drivemanager/presenter/controllers/home_controller.dart';
import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/screens/message_screen.dart';
import 'package:drivemanager/core/utils/load_panel.dart';

class HomeScreen extends StatefulWidget {
  final LoginController loginController;

  const HomeScreen({super.key, required this.loginController});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late HomeController _homeController;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(
      widget.loginController,
      (isLoggingOut) {
        if (mounted) {
          // Verifica se o widget está montado
          setState(() {
            _isLoggingOut = isLoggingOut;
          });
        }
      },
    );
    _homeController.fetchMessages().then((_) {
      if (mounted) {
        // Verifica se o widget está montado
        setState(() {});
      }
    });
    _homeController.subscribeNotifications((message) {
      if (mounted) {
        // Verifica se o widget está montado
        _showSnackBar(message);
      }
    });
  }

  @override
  void dispose() {
    _homeController.unsubscribeNotifications();
    super.dispose();
  }

  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Verifica se o widget está montado
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
                    builder: (context) => MessageScreen(messages: _homeController.messages),
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
            onSelected: (result) {
              _homeController.handleMenuSelection(result);
            },
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
