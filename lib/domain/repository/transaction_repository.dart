import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';

abstract class TransactionRepository {

  Future<List<Transaction>> getTransactions();
  Future<Totals> getTotals(int year, int month);
}