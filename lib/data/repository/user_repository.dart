import 'package:get_storage/get_storage.dart';

abstract class UserRepository {
  String getUserName();
  Future<void> saveUserName(String userName);
}

class UserRepositoryImpl implements UserRepository {
  final GetStorage _box;

  UserRepositoryImpl(this._box);

  @override
  String getUserName() {
    return _box.read('user_name') ?? 'Usuário';
  }

  @override
  Future<void> saveUserName(String userName) async {
    await _box.write('user_name', userName);
  }
}
