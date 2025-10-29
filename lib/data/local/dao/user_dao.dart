import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/local/table/users_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  final AppDatabase db;

  UserDao(this.db) : super(db);

  Future<User?> getUserByUsername(String username) {
    return (select(users)..where((u) => u.username.equals(username))).getSingleOrNull();
  }

  Future<User?> getUserByUsernameAndPassword(String username, String password) {
    return (select(users)..where(
          (u) => u.username.equals(username) & u.password.equals(password),
        ))
        .getSingleOrNull();
  }

  Future<void> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<List<User>> getAllUsers() => select(users).get();

  Future<int> deleteUser(int id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();
}
