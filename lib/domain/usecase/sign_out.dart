import 'package:drivemanager/data/repository/auth_repository.dart';

class SignOut {
  final AuthRepository _authRepository;

  SignOut(this._authRepository);

  Future<void> execute() async {
    await _authRepository.signOut();
  }
}
