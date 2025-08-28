import 'package:drivemanager/data/repository/user_repository.dart';

class GetUserName {
  final UserRepository _userRepository;

  GetUserName(this._userRepository);

  String execute() {
    return _userRepository.getUserName();
  }
}
