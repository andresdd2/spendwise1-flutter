import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/infrastructure/mappers/category_mapper.dart';
import 'package:spendwise_1/infrastructure/models/transaction_model.dart';

class TransactionMapper {

  static Transaction toEntity(TransactionModel model) {
    return Transaction(
      id: model.id, 
      amount: model.amount, 
      description: model.description, 
      date: model.date, 
      category: CategoryMapper.toEntity(model.category), 
      type: model.type
    );
  }

  static List<Transaction> toEntities(List<TransactionModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }
}