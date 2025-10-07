import 'package:spendwise_1/domain/entity/dailay_totals.dart';
import 'package:spendwise_1/domain/entity/monthly_totals.dart';
import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/domain/entity/totals_by_category.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';

abstract class TransactionRepository {

  Future<List<Transaction>> getTransactions({int? limit});
  Future<Totals> getTotals(int year, int month);
  Future<List<TotalsByCategory>> getTotalsByCategory(int year, int month);
  Future<List<MonthlyTotals>> getMonthlyTotals(int year);
  Future<List<DailyTotals>> getDailyTotals(int year, int month);
  Future<String> createTransaction(Transaction transaction);
}