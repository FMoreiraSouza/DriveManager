import 'package:drivemanager/core/constants/database_keys.dart';
import 'package:drivemanager/core/themes/app_theme.dart';
import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:drivemanager/presenter/screens/fleet_register_screen.dart';
import 'package:drivemanager/presenter/screens/fleet_screen.dart';
import 'package:drivemanager/presenter/screens/home_screen.dart';
import 'package:drivemanager/presenter/screens/info_screen.dart';
import 'package:drivemanager/presenter/screens/login_screen.dart';
import 'package:drivemanager/presenter/screens/map_screen.dart';
import 'package:drivemanager/presenter/screens/message_screen.dart';
import 'package:drivemanager/presenter/widgets/fleet_list.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bcoarfctxsldjaidxdii.supabase.co',
    anonKey: supabaseKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;
    final loginController = LoginController(supabaseClient);
    return MaterialApp(
      title: 'Fleet Management',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      home: FutureBuilder<bool>(
        future: loginController.isAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen(loginController: loginController);
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(loginController: loginController),
        '/info': (context) => const InfoScreen(),
        '/fleet-register': (context) => const FleetRegisterScreen(),
        '/fleet': (context) => const FleetScreen(),
        '/flee-list': (context) => const FleetList(),
        '/messages': (context) => const MessageScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}
