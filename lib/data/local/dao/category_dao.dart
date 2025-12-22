import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/local/table/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  final AppDatabase db;

  CategoryDao(this.db) : super(db);

  Future<List<Category>> getAllCategories() =>
      (select(categories)..where((c) => c.deletedAt.isNull())).get();

  Future<void> addCategory(CategoriesCompanion category) =>
      into(categories).insert(category);

  Future<bool> updateCategory(CategoriesCompanion category) =>
      update(categories).replace(category);

  Future<int> softDeleteCategory(int id) =>
      (update(categories)..where((c) => c.id.equals(id))).write(
        CategoriesCompanion(deletedAt: Value(DateTime.now())),
      );

  Future<int> permanentlyDeleteCategory(int id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  Future<int> restoreCategory(int id) =>
      (update(categories)..where((c) => c.id.equals(id))).write(
        const CategoriesCompanion(deletedAt: Value(null)),
      );

  Future<List<Category>> getDeletedCategories() =>
      (select(categories)..where((c) => c.deletedAt.isNotNull())).get();

  Stream<List<Category>> getAllCategoriesStream() =>
      (select(categories)..where((c) => c.deletedAt.isNull())).watch();

  Stream<List<Category>> getDeletedCategoriesStream() =>
      (select(categories)..where((c) => c.deletedAt.isNotNull())).watch();
}
