import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/models/category.dart';

@lazySingleton
class CategoryRepository {
  final AppDatabase _db;

  const CategoryRepository(this._db);

  Future<List<Category>> getAllCategories() {
    return _db.select(_db.categories).get();
  }

  Future<void> addCategory(Category category) {
    final companion = CategoriesCompanion.insert(
      name: category.name,
      description: Value(category.description),
    );
    return _db.into(_db.categories).insert(companion);
  }

  Future<bool> updateCategory(Category category) {
    final companion = CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      description: Value(category.description),
    );
    return _db.update(_db.categories).replace(companion);
  }

  Future<int> deleteCategory(int id) {
    return (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();
  }
}
