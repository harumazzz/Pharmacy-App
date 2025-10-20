import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/models/user.dart';

@lazySingleton
class AuthRepository {
  final AppDatabase _db;

  const AuthRepository(this._db);

  Future<User?> login(String username, String password) async {
    return (_db.select(_db.users)..where(
          (u) => u.username.equals(username) & u.password.equals(password),
        ))
        .getSingleOrNull();
  }

  Future<void> register(User user) {
    final companion = UsersCompanion.insert(
      username: user.username,
      password: user.password,
      fullName: Value(user.fullName),
      role: user.role,
    );
    return _db.into(_db.users).insert(companion);
  }

  Future<List<User>> getAllUsers() {
    return _db.select(_db.users).get();
  }

  Future<int> deleteUser(int id) {
    return (_db.delete(_db.users)..where((u) => u.id.equals(id))).go();
  }
}
