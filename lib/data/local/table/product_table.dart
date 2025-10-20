import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/table/category_table.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  RealColumn get price => real()();
  IntColumn get stockQuantity => integer().withDefault(const Constant(0))();
  TextColumn get imageUrl => text().nullable()();
  
  IntColumn get categoryId => integer().references(Categories, #id)();
}