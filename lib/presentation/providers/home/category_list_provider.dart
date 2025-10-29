import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/data/models/category.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';

part 'category_list_provider.g.dart';

@riverpod
Stream<List<Category>> categoryList(Ref ref) {
  final categoryRepo = ref.watch(categoryRepositoryProvider);
  return categoryRepo.watchCategories();
}
