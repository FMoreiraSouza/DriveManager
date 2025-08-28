import 'package:drivemanager/data/repository/user_repository.dart';

class SaveUserName {
  final UserRepository _userRepository;

  SaveUserName(this._userRepository);

  Future<void> execute(String userName) async {
    await _userRepository.saveUserName(userName);
  }
}
