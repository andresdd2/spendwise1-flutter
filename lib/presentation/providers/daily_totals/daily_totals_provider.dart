import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/dailay_totals.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';

final dailyTotalsProvider =
    FutureProvider.family<List<DailyTotals>, ({int year, int month})>((
      ref,
      params,
    ) async {
      final repository = ref.watch(transactionRepositoryProvider);
      return await repository.getDailyTotals(params.year, params.month);
    });