import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/domain/repositories/category_repository.dart'
    as domain;
import 'package:pharmacy_app/data/models/category.dart' as model;

@LazySingleton(as: domain.CategoryRepository)
class CategoryRepositoryImpl implements domain.CategoryRepository {
  final AppDatabase _db;

  const CategoryRepositoryImpl(this._db);

  @override
  Stream<List<model.Category>> watchCategories() {
    return _db
        .select(_db.categories)
        .watch()
        .map(
          (categories) => categories
              .map(
                (category) => model.Category(
                  id: category.id,
                  name: category.name,
                  description: category.description,
                ),
              )
              .toList(),
        );
  }
}
