import 'package:drivemanager/data/repository/contract/user_repository.dart';

class SaveUserNameUsecase {
  final UserRepository _userRepository;

  SaveUserNameUsecase(this._userRepository);

  Future<void> execute(String userName) async {
    await _userRepository.saveUserName(userName);
  }
}
