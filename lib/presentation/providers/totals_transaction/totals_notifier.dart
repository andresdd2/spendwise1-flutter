import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/repository/transaction_repository.dart';
import 'package:spendwise_1/presentation/providers/totals_transaction/totals_state.dart';

class TotalsNotifier extends StateNotifier<TotalsState> {
  final TransactionRepository repository;
  final int year;
  final int month;

  TotalsNotifier(this.repository, this.year, this.month)
    : super(TotalsState()) {
    loadTotals();
  }

  Future<void> loadTotals() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final totals = await repository.getTotals(year, month);
      state = state.copyWith(totals: totals, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}