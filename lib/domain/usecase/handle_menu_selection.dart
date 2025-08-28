import 'package:drivemanager/data/repository/auth_repository.dart';
import 'package:drivemanager/routes/navigation_service.dart';

class HandleMenuSelection {
  final AuthRepository _authRepository;

  HandleMenuSelection(this._authRepository);

  Future<void> execute(String selection) async {
    switch (selection) {
      case 'info':
        NavigationService.pushNamed('/info');
        break;
      case 'sair':
        await _authRepository.signOut();
        break;
    }
  }
}
