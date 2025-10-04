import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';
import 'package:spendwise_1/infrastructure/datasource/transaction_datasource_impl.dart';
import 'package:spendwise_1/infrastructure/repository/transaction_repository_impl.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final datasource = TransactionDatasourceImpl();
  return TransactionRepositoryImpl(datasource: datasource);
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactions();
});

final totalsProvider = FutureProvider.family<Totals, (int, int)>((ref, params) async {
  final (year, month) = params;
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTotals(year, month);
});