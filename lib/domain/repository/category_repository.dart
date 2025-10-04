import 'package:spendwise_1/domain/entity/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}