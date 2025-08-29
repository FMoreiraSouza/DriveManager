import 'package:drivemanager/data/repository/contract/auth_repository.dart';

class CheckAuthenticationUsecase {
  final AuthRepository _authRepository;

  CheckAuthenticationUsecase(this._authRepository);

  Future<bool> execute() async {
    return await _authRepository.isAuthenticated();
  }
}
