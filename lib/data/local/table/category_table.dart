import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/models/category.dart';

@UseRowClass(Category)
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get description => text().nullable()();
}
