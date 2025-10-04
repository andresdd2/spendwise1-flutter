import 'package:spendwise_1/domain/entity/category.dart';

abstract class CategoryDatasource {
  Future<List<Category>> getCategories();
}