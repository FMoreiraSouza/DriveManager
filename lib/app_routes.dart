import 'package:flutter/material.dart' hide Notification;
import 'package:drivemanager/data/model/notification.dart';
import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/screens/fleet_register_screen.dart';
import 'package:drivemanager/presenter/screens/fleet_screen.dart';
import 'package:drivemanager/presenter/screens/home_screen.dart';
import 'package:drivemanager/presenter/screens/info_screen.dart';
import 'package:drivemanager/presenter/screens/login_screen.dart';
import 'package:drivemanager/presenter/screens/map_screen.dart';
import 'package:drivemanager/presenter/screens/message_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String messages = '/messages';
  static const String info = '/info';
  static const String fleet = '/fleet';
  static const String fleetRegister = '/fleet-register';
  static const String map = '/map';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(loginController: args as LoginController),
        );

      case messages:
        return MaterialPageRoute(
          builder: (_) => MessageScreen(
            messages: args as List<Notification>,
          ),
        );

      case info:
        return MaterialPageRoute(builder: (_) => const InfoScreen());

      case fleet:
        return MaterialPageRoute(builder: (_) => const FleetScreen());

      case fleetRegister:
        return MaterialPageRoute(builder: (_) => const FleetRegisterScreen());

      case map:
        return MaterialPageRoute(builder: (_) => const MapScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Map<String, WidgetBuilder> getRoutes(LoginController loginController) {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => HomeScreen(loginController: loginController),
      messages: (context) => const MessageScreen(
            messages: [], // Fallback vazio, espera argumentos dinâmicos
          ),
      info: (context) => const InfoScreen(),
      fleet: (context) => const FleetScreen(),
      fleetRegister: (context) => const FleetRegisterScreen(),
      map: (context) => const MapScreen(),
    };
  }
}
