import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';
import 'package:spendwise_1/infrastructure/datasource/transaction_datasource_impl.dart';
import 'package:spendwise_1/infrastructure/repository/transaction_repository_impl.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_notifier.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_state.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final datasource = TransactionDatasourceImpl();
  return TransactionRepositoryImpl(datasource: datasource);
});

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
      final repository = ref.watch(transactionRepositoryProvider);
      return TransactionsNotifier(repository);
    });

    final transactionByIdProvider = FutureProvider.family<Transaction, String>((ref, id) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getTransactionById(id);
});