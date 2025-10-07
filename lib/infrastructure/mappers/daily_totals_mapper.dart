import 'package:spendwise_1/domain/entity/dailay_totals.dart';
import 'package:spendwise_1/infrastructure/models/daily_totals_model.dart';

class DailyTotalsMapper {
  static DailyTotals toEntity(DailyTotalsModel model) {
    return DailyTotals(
      day: model.day,
      income: model.income,
      expense: model.expense,
    );
  }

  static List<DailyTotals> toEntities(List<DailyTotalsModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }
}