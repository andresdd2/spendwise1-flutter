import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/presentation/providers/totals_transaction/totals_notifier.dart';
import 'package:spendwise_1/presentation/providers/totals_transaction/totals_state.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';

final totalsProvider =
    StateNotifierProvider.family<TotalsNotifier, TotalsState, (int, int)>((
      ref,
      params,
    ) {
      final (year, month) = params;
      final repository = ref.watch(transactionRepositoryProvider);
      return TotalsNotifier(repository, year, month);
    });