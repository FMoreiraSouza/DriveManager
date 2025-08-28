import 'package:drivemanager/data/repository/auth_repository.dart';
import 'package:drivemanager/data/repository/user_repository.dart';
import 'package:drivemanager/domain/usecase/sign_in.dart';
import 'package:drivemanager/domain/usecase/sign_out.dart';
import 'package:drivemanager/domain/usecase/check_authentication.dart';
import 'package:drivemanager/routes/navigation_service.dart';

class LoginController {
  final SignIn _signIn;
  final SignOut _signOut;
  final CheckAuthentication _checkAuthentication;

  LoginController({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _signIn = SignIn(authRepository, userRepository),
        _signOut = SignOut(authRepository),
        _checkAuthentication = CheckAuthentication(authRepository);

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _signIn.execute(email: email, password: password);
      NavigationService.pushReplacementNamed('/home');
    } catch (e) {
      NavigationService.showSnackBar('Erro ao fazer login: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _signOut.execute();
      NavigationService.pushReplacementNamed('/login');
    } catch (e) {
      NavigationService.showSnackBar('Erro ao fazer logout: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    return await _checkAuthentication.execute();
  }
}
