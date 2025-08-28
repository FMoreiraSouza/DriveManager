import 'package:drivemanager/routes/app_routes.dart';
import 'package:drivemanager/core/constants/database_keys.dart';
import 'package:drivemanager/core/themes/app_theme.dart';
import 'package:drivemanager/routes/navigation_service.dart';
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
    return MaterialApp(
      title: 'Drive Manager',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      routes: AppRoutes.getRoutes(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
