import '../../data/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(User user);
  Future<void> logout();
}
