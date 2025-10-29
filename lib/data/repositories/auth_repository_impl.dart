import 'package:pharmacy_app/domain/exceptions/auth_exceptions.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/domain/repositories/auth_repository.dart'
    as domain;
import 'package:pharmacy_app/data/models/user.dart' as model;

@LazySingleton(as: domain.AuthRepository)
class AuthRepositoryImpl implements domain.AuthRepository {
  final AppDatabase _db;

  const AuthRepositoryImpl(this._db);

  @override
  Future<void> login(String email, String password) async {
    final user = await _db.userDao.getUserByUsernameAndPassword(
      email,
      password,
    );
    if (user == null) {
      throw const InvalidCredentialsException();
    }
    // Perhaps store current user or something, but for now, just check.
  }

  @override
  Future<void> register(model.User user) async {
    final existingUser = await _db.userDao.getUserByUsername(user.username);
    if (existingUser != null) {
      throw const EmailAlreadyInUseException();
    }
    final companion = UsersCompanion.insert(
      username: user.username,
      password: user.password,
      fullName: Value(user.fullName),
      role: user.role,
    );
    return _db.userDao.insertUser(companion);
  }

  @override
  Future<void> logout() async {
    // Implement logout logic, perhaps clear session.
  }
}
