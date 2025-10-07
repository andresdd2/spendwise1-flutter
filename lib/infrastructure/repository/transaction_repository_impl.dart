import 'package:spendwise_1/domain/datasource/transaction_datasource.dart';
import 'package:spendwise_1/domain/entity/dailay_totals.dart';
import 'package:spendwise_1/domain/entity/monthly_totals.dart';
import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/domain/entity/totals_by_category.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDatasource datasource;

  TransactionRepositoryImpl({required this.datasource});

  @override
  Future<List<Transaction>> getTransactions({int? limit}) async {
    return await datasource.getTransactions(limit: limit);
  }

  @override
  Future<Totals> getTotals(int year, int month) async {
    return await datasource.getTotals(year, month);
  }

  @override
  Future<String> createTransaction(Transaction transaction) async {
    return await datasource.createTransaction(transaction);
  }

  @override
  Future<List<TotalsByCategory>> getTotalsByCategory(int year, int month) async {
    return await datasource.getTotalsByCategory(year, month);
  }

  @override
  Future<List<MonthlyTotals>> getMonthlyTotals(int year) async {
    return await datasource.getMonthlyTotals(year);
  }

  @override
  Future<List<DailyTotals>> getDailyTotals(int year, int month) async {
    return await datasource.getDailyTotals(year, month);
  }
}