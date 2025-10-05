import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_state.dart';

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  final TransactionRepository repository;

  TransactionsNotifier(this.repository) : super(TransactionsState()) {
    loadTransactions(); // Carga automática al inicializar
  }

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final transactions = await repository.getTransactions();
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // CRUD OPERATIONS
  Future<void> addTransaction(Transaction transaction) async {
    try {
      // Aquí llamarías a tu método del repository para crear
      // await repository.createTransaction(transaction);

      // Actualización optimista (opcional)
      state = state.copyWith(
        transactions: [...state.transactions, transaction],
      );

      // Recargar para sincronizar con el servidor
      await loadTransactions();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
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
