import 'package:drift/drift.dart';

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer()();
  IntColumn get productId => integer()();
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
}
