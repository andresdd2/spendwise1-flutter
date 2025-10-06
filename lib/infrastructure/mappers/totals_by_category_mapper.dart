import 'package:spendwise_1/domain/entity/totals_by_category.dart';
import 'package:spendwise_1/infrastructure/models/totals_by_category_model.dart';

class TotalsByCategoryMapper {
  static TotalsByCategory toEntity(TotalsByCategoryModel model) {
    return TotalsByCategory(
      categoryId: model.categoryId,
      categoryName: model.categoryName,
      totalIncome: model.totalIncome,
      totalExpense: model.totalExpense,
      incomeCount: model.incomeCount,
      expenseCount: model.expenseCount,
    );
  }

  static List<TotalsByCategory> toEntities(List<TotalsByCategoryModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }
}
