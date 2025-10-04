import 'package:spendwise_1/domain/datasource/category_datasource.dart';
import 'package:spendwise_1/domain/entity/category.dart';
import 'package:spendwise_1/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource datasource;

  CategoryRepositoryImpl({required this.datasource});

  @override
  Future<List<Category>> getCategories() async {
    return await datasource.getCategories();
  }
}