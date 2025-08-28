import 'package:get_storage/get_storage.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController {
  final SupabaseClient _supabaseClient;

  LoginController(this._supabaseClient);

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
        String userName = email.split('@')[0].toUpperCase();
        final box = GetStorage();
        box.write('user_name', userName);
        NavigationService.pushReplacementNamed('/home');
      } else {
        NavigationService.showSnackBar('Login falhou. Tente novamente.');
      }
    } catch (e) {
      NavigationService.showSnackBar(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      NavigationService.pushReplacementNamed('/login');
    } catch (e) {
      NavigationService.showSnackBar('Erro ao fazer logout. Tente novamente.');
    }
  }

  Future<bool> isAuthenticated() async {
    final session = _supabaseClient.auth.currentSession;
    return session != null;
  }
}
