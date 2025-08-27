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
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante que a inicialização do Flutter ocorra antes de executar código assíncrono
  await GetStorage.init();
  await Supabase.initialize(
    url: urlKey, // URL do Supabase
    anonKey: supabaseKey, // Chave anônima do Supabase
  );

  runApp(const MyApp()); // Executa o aplicativo Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client; // Obtém o cliente Supabase
    final loginController = LoginController(supabaseClient); // Inicializa o controlador de login
    return MaterialApp(
      title: 'Drive Ma', // Título do aplicativo
      theme: AppTheme.theme, // Tema do aplicativo
      debugShowCheckedModeBanner: false, // Desativa a faixa de depuração
      navigatorKey: NavigationService.navigatorKey, // Configura a chave do navegador global
      initialRoute: '/', // Rota inicial
      home: FutureBuilder<bool>(
        future: loginController.isAuthenticated(), // Verifica se o usuário está autenticado
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Exibe um indicador de progresso enquanto espera
          }
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen(
                loginController:
                    loginController); // Exibe a tela inicial se o usuário estiver autenticado
          } else {
            return const LoginScreen(); // Exibe a tela de login se o usuário não estiver autenticado
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(loginController: loginController),
        '/messages': (context) => const MessageScreen(),
        '/info': (context) => const InfoScreen(),
        '/fleet': (context) => const FleetScreen(),
        '/fleet-register': (context) => const FleetRegisterScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}
