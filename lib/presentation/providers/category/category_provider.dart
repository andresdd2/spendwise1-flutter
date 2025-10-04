import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/category.dart';
import 'package:spendwise_1/domain/repository/category_repository.dart';
import 'package:spendwise_1/infrastructure/datasource/category_datasource_impl.dart';
import 'package:spendwise_1/infrastructure/repository/category_repository_impl.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final datasource = CategoryDatasourceImpl();
  return CategoryRepositoryImpl(datasource: datasource);
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategories();
});