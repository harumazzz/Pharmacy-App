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
  Future<model.User> login(String email, String password) async {
    final user = await _db.userDao.getUserByUsernameAndPassword(
      email,
      password,
    );
    if (user == null) {
      throw const InvalidCredentialsException();
    }
    final userModel = model.User(
      id: user.id,
      username: user.username,
      password: user.password,
      fullName: user.fullName,
      role: user.role,
    );
    _setCurrentUser(userModel);
    return userModel;
  }

  @override
  Future<model.User> register(model.User user) async {
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
    await _db.userDao.insertUser(companion);
    final currentUser = await _db.userDao.getUserByUsername(user.username);
    if (currentUser == null) {
      throw Exception('User registration failed');
    }
    final userModel = model.User(
      id: currentUser.id,
      username: currentUser.username,
      password: currentUser.password,
      fullName: currentUser.fullName,
      role: currentUser.role,
    );
    _setCurrentUser(userModel);
    return userModel;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  static model.User? _currentUser;

  @override
  Future<model.User?> getCurrentUser() async {
    return _currentUser;
  }

  void _setCurrentUser(model.User user) {
    _currentUser = user;
  }
}
