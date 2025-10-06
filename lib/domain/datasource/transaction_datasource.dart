import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/domain/entity/totals_by_category.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';

abstract class TransactionDatasource {

  Future<List<Transaction>> getTransactions();
  Future<Totals> getTotals(int year, int month);
  Future<List<TotalsByCategory>> getTotalsByCategory(int year, int month);
  Future<String> createTransaction(Transaction transaction);
}