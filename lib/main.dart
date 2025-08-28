import 'package:drivemanager/app_routes.dart';
import 'package:drivemanager/core/constants/database_keys.dart';
import 'package:drivemanager/core/themes/app_theme.dart';
import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:drivemanager/presenter/screens/home_screen.dart';
import 'package:drivemanager/presenter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Supabase.initialize(
    url: urlKey,
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
      title: 'Drive Manager',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
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
      routes: AppRoutes.getRoutes(loginController),
    );
  }
}
