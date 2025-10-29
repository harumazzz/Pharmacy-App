import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  RealColumn get price => real()();
  IntColumn get stockQuantity => integer()();
  IntColumn get categoryId => integer()();
  TextColumn get imageUrl => text()();
}
