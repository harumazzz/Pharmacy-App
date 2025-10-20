import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/table/user_table.dart';

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  IntColumn get userId => integer().references(Users, #id)();
  
  RealColumn get totalPrice => real()();
  TextColumn get status => text()();
  TextColumn get shippingAddress => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}