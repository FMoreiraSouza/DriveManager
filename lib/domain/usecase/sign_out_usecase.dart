import 'package:drivemanager/data/repository/contract/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _authRepository;

  SignOutUsecase(this._authRepository);

  Future<void> execute() async {
    await _authRepository.signOut();
  }
}
