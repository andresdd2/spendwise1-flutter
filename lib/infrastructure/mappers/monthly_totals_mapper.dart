import 'package:spendwise_1/domain/entity/monthly_totals.dart';
import 'package:spendwise_1/infrastructure/models/monthly_totals_model.dart';

class MonthlyTotalsMapper {
  static MonthlyTotals toEntity(MonthlyTotalsModel model) {
    return MonthlyTotals(
      month: model.month,
      income: model.income,
      expense: model.expense,
    );
  }

  static List<MonthlyTotals> toEntities(List<MonthlyTotalsModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }
}