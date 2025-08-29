import 'package:drivemanager/data/repository/contract/user_repository.dart';
import 'package:drivemanager/domain/usecase/get_username_usecase.dart';

class InfoController {
  final GetUserNameUsecase _getUserName;

  InfoController(UserRepository userRepository) : _getUserName = GetUserNameUsecase(userRepository);

  String getUserName() {
    return _getUserName.execute();
  }
}
