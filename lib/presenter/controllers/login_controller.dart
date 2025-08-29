import 'package:drivemanager/routes/navigation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController {
  final SupabaseClient _supabase;

  LoginController({
    required SupabaseClient supabase,
  }) : _supabase = supabase;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Falha no login: usuário não retornado');
      }

      NavigationService.pushReplacementNamed('/home');
    } catch (e) {
      NavigationService.showSnackBar('Erro ao fazer login: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      NavigationService.pushReplacementNamed('/login');
    } catch (e) {
      NavigationService.showSnackBar('Erro ao fazer logout: $e');
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final session = _supabase.auth.currentSession;
      return session != null;
    } catch (e) {
      return false;
    }
  }
}
