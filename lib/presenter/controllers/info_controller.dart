import 'package:drivemanager/data/repository/user_repository.dart';
import 'package:drivemanager/domain/usecase/get_username.dart';

class InfoController {
  final GetUserName _getUserName;

  InfoController(UserRepository userRepository) : _getUserName = GetUserName(userRepository);

  String getUserName() {
    return _getUserName.execute();
  }
}
