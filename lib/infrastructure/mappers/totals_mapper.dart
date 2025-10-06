import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/infrastructure/models/totals_model.dart';

class TotalsMapper {

  static Totals toEntity(TotalsModel model) {
    return Totals(
      income: model.income, 
      expense: model.expense
    );
  }
}