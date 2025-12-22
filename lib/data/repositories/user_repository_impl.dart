import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/domain/repositories/user_repository.dart'
    as domain;
import 'package:pharmacy_app/data/models/user.dart' as model;

@LazySingleton(as: domain.UserRepository)
class UserRepositoryImpl implements domain.UserRepository {
  final AppDatabase _db;

  const UserRepositoryImpl(this._db);

  @override
  Stream<List<model.User>> watchAllUsers() {
    return _db.select(_db.users).watch().map(
      (users) => users
          .map(
            (user) => model.User(
              id: user.id,
              username: user.username,
              password: user.password,
              fullName: user.fullName,
              role: user.role,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<List<model.User>> getAllUsers() async {
    final users = await _db.select(_db.users).get();
    return users
        .map(
          (user) => model.User(
            id: user.id,
            username: user.username,
            password: user.password,
            fullName: user.fullName,
            role: user.role,
          ),
        )
        .toList();
  }
}
