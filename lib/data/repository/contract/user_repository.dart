abstract class UserRepository {
  String getUserName();
  Future<void> saveUserName(String userName);
}
