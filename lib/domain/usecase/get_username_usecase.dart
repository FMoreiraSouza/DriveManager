import 'package:drivemanager/data/repository/contract/user_repository.dart';

class GetUserNameUsecase {
  final UserRepository _userRepository;

  GetUserNameUsecase(this._userRepository);

  String execute() {
    return _userRepository.getUserName();
  }
}
