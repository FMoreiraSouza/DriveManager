import 'package:drivemanager/view/screens/fleet_register_screen.dart';
import 'package:drivemanager/view/screens/fleet_screen.dart';
import 'package:drivemanager/view/screens/home_screen.dart';
import 'package:drivemanager/view/screens/info_screen.dart';
import 'package:drivemanager/view/screens/login_screen.dart';
import 'package:drivemanager/view/screens/map_screen.dart';
import 'package:drivemanager/view/screens/message_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/fleet':
        return MaterialPageRoute(builder: (_) => const FleetScreen());
      case '/fleet_register':
        return MaterialPageRoute(builder: (_) => const FleetRegisterScreen());
      case '/map':
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case '/messages':
        return MaterialPageRoute(
          builder: (_) => const MessageScreen(
            messages: [],
          ),
        );
      case '/info':
        return MaterialPageRoute(builder: (_) => const InfoScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: const Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (_) => const LoginScreen(),
      '/login': (_) => const LoginScreen(),
      '/home': (_) => const HomeScreen(),
      '/fleet': (_) => const FleetScreen(),
      '/fleet_register': (_) => const FleetRegisterScreen(),
      '/map': (_) => const MapScreen(),
      '/messages': (_) => const MessageScreen(messages: []),
      '/info': (_) => const InfoScreen(),
    };
  }
}
