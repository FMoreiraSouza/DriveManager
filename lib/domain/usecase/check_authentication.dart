import 'package:drivemanager/data/repository/auth_repository.dart';

class CheckAuthentication {
  final AuthRepository _authRepository;

  CheckAuthentication(this._authRepository);

  Future<bool> execute() async {
    return await _authRepository.isAuthenticated();
  }
}
