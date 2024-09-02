import 'package:get_storage/get_storage.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controlador para gerenciamento de login
class LoginController {
  final SupabaseClient _supabaseClient; // Cliente Supabase

  LoginController(this._supabaseClient);

  // Função para autenticar o usuário
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        // Extraia o nome do usuário até o símbolo '@'
        String userName = email.split('@')[0].toUpperCase();

        // Salve o nome do usuário no GetStorage
        final box = GetStorage();
        box.write('user_name', userName);

        NavigationService.pushReplacementNamed('/home'); // Navega para a tela inicial
      } else {
        NavigationService.showSnackBar('Login falhou. Tente novamente.'); // Exibe mensagem de erro
      }
    } catch (e) {
      NavigationService.showSnackBar(e.toString()); // Exibe mensagem de erro
    }
  }

  // Função para sair da conta
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      NavigationService.pushReplacementNamed('/login'); // Navega de volta para a tela de login
    } catch (e) {
      NavigationService.showSnackBar(
          'Erro ao fazer logout. Tente novamente.'); // Exibe mensagem de erro
    }
  }

  // Verifica se o usuário está autenticado
  Future<bool> isAuthenticated() async {
    final session = _supabaseClient.auth.currentSession;
    return session != null; // Retorna true se a sessão estiver ativa
  }
}
