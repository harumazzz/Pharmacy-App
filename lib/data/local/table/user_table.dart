import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/models/user.dart';

@UseRowClass(User)
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get password => text()();
  TextColumn get fullName => text().nullable()();
  TextColumn get role => text()();
}
