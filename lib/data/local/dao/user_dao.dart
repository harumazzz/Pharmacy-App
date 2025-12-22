import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/local/table/users_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  final AppDatabase db;

  UserDao(this.db) : super(db);

  Future<User?> getUserByUsername(String username) {
    return (select(users)
          ..where((u) => u.username.equals(username) & u.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<User?> getUserByUsernameAndPassword(String username, String password) {
    return (select(users)..where(
          (u) =>
              u.username.equals(username) &
              u.password.equals(password) &
              u.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<List<User>> getAllUsers() =>
      (select(users)..where((u) => u.deletedAt.isNull())).get();

  Future<int> softDeleteUser(int id) =>
      (update(users)..where((u) => u.id.equals(id))).write(
        UsersCompanion(deletedAt: Value(DateTime.now())),
      );

  Future<int> permanentlyDeleteUser(int id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();

  Future<int> restoreUser(int id) =>
      (update(users)..where((u) => u.id.equals(id))).write(
        const UsersCompanion(deletedAt: Value(null)),
      );

  Future<List<User>> getDeletedUsers() =>
      (select(users)..where((u) => u.deletedAt.isNotNull())).get();

  Stream<List<User>> getAllUsersStream() =>
      (select(users)..where((u) => u.deletedAt.isNull())).watch();

  Stream<List<User>> getDeletedUsersStream() =>
      (select(users)..where((u) => u.deletedAt.isNotNull())).watch();
}
