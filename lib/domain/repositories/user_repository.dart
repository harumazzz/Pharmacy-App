import '../../data/models/user.dart';

abstract class UserRepository {
  Stream<List<User>> watchAllUsers();
  Future<List<User>> getAllUsers();
}
