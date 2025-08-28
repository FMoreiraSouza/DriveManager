import 'package:drivemanager/data/repository/contract/auth_repository.dart';
import 'package:drivemanager/data/repository/contract/user_repository.dart';

class SignInUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignInUsecase(this._authRepository, this._userRepository);

  Future<void> execute({required String email, required String password}) async {
    await _authRepository.signIn(email: email, password: password);
    final userName = email.split('@')[0].toUpperCase();
    await _userRepository.saveUserName(userName);
  }
}
