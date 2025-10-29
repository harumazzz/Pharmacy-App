import '../../data/models/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchCategories();
}
