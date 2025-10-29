import 'package:drift/drift.dart';

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  RealColumn get totalPrice => real()();
  TextColumn get status => text()();
  TextColumn get shippingAddress => text()();
  DateTimeColumn get createdAt => dateTime()();
}
