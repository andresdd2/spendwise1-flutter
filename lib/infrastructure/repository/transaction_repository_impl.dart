import 'package:spendwise_1/domain/datasource/transaction_datasource.dart';
import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDatasource datasource;

  TransactionRepositoryImpl({required this.datasource});

  @override
  Future<List<Transaction>> getTransactions() async {
    return await datasource.getTransactions();
  }

  @override
  Future<Totals> getTotals(int year, int month) async {
    return await datasource.getTotals(year, month);
  }
  
  @override
  Future<String> createTransaction(Transaction transaction) async {
    return await datasource.createTransaction(transaction);
  }
}