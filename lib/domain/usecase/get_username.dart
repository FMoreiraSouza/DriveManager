import 'package:drivemanager/data/repository/contract/user_repository.dart';

class GetUserName {
  final UserRepository _userRepository;

  GetUserName(this._userRepository);

  String execute() {
    return _userRepository.getUserName();
  }
}
