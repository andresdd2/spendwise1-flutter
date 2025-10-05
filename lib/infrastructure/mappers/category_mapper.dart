import 'package:spendwise_1/domain/entity/category.dart';
import 'package:spendwise_1/infrastructure/models/category_model.dart';

class CategoryMapper {
  static Category toEntity(CategoryModel model) {
    return Category(id: model.id, name: model.name);
  }

  static List<Category> toEntities(List<CategoryModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  static CategoryModel toModel(Category entity) {
    return CategoryModel(id: entity.id, name: entity.name);
  }
}