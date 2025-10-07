import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_state.dart';

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  final TransactionRepository repository;

  TransactionsNotifier(this.repository) : super(TransactionsState()) {
    loadTransactions(limit: 10);
  }

  Future<void> loadTransactions({int? limit}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final transactions = await repository.getTransactions(limit: limit);
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<String> addTransaction(Transaction transaction) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final message = await repository.createTransaction(transaction);
      state = state.copyWith(
        transactions: [...state.transactions, transaction],
        isLoading: false,
      );
      await loadTransactions();
      return message;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      // await repository.updateTransaction(transaction);

      final updatedList = state.transactions.map((t) {
        return t.id == transaction.id ? transaction : t;
      }).toList();

      state = state.copyWith(transactions: updatedList);
      await loadTransactions();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      // await repository.deleteTransaction(id);

      final updatedList = state.transactions.where((t) => t.id != id).toList();
      state = state.copyWith(transactions: updatedList);

      await loadTransactions();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }
}