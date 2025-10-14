import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_state.dart';

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  final TransactionRepository repository;
  bool _isDisposed = false;

  TransactionsNotifier(this.repository) : super(TransactionsState()) {
    loadTransactions(limit: 10);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadTransactions({int? limit}) async {
    if (_isDisposed) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final transactions = await repository.getTransactions(limit: limit);
      if (!_isDisposed) {
        state = state.copyWith(transactions: transactions, isLoading: false);
      }
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  Future<void> loadTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (_isDisposed) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final transactions = await repository.getTransactionsByDateRange(
        startDate,
        endDate,
      );
      if (!_isDisposed) {
        state = state.copyWith(transactions: transactions, isLoading: false);
      }
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  Future<String> addTransaction(Transaction transaction) async {
    if (_isDisposed) return Future.value('');
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final message = await repository.createTransaction(transaction);
      if (!_isDisposed) {
        state = state.copyWith(
          transactions: [...state.transactions, transaction],
          isLoading: false,
        );
        await loadTransactions();
      }
      return message;
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      throw Exception(e);
    }
  }

  Future<String> updateTransaction(String id, Transaction transaction) async {
    if (_isDisposed) return Future.value('');
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final message = await repository.updateTransaction(id, transaction);
      if (!_isDisposed) {
        await loadTransactions();
        state = state.copyWith(isLoading: false);
      }
      return message;
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      throw Exception(e);
    }
  }

  Future<String> deleteTransaction(String id) async {
    if (_isDisposed) return Future.value('');
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final message = await repository.deleteTransaction(id);
      if (!_isDisposed) {
        await loadTransactions();
        state = state.copyWith(isLoading: false);
      }
      return message;
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      throw Exception(e);
    }
  }
}