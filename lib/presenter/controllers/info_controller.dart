import 'package:get_storage/get_storage.dart';

class InfoController {
  final GetStorage _box;

  InfoController(this._box);

  String getUserName() {
    return _box.read('user_name') ?? 'Usuário';
  }
}
