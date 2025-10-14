import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_state.dart';

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  final TransactionRepository repository;

  TransactionsNotifier(this.repository) : super(TransactionsState()) {
    loadTransactions(limit: 10);
  }

  @override
  void dispose() {
    state = TransactionsState();
    super.dispose();
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

  Future<void> loadTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final transactions = await repository.getTransactionsByDateRange(
        startDate,
        endDate,
      );
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

  Future<String> updateTransaction(String id, Transaction transaction) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final message = await repository.updateTransaction(id, transaction);
      await loadTransactions();
      state = state.copyWith(isLoading: false);
      return message;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }

  Future<String> deleteTransaction(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final message = await repository.deleteTransaction(id);
      await loadTransactions();
      state = state.copyWith(isLoading: false);
      return message;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }
}
