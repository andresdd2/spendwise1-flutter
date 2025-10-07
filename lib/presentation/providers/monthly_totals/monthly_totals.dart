import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/monthly_totals.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';

final monthlyTotalsProvider = FutureProvider.family<List<MonthlyTotals>, int>((
  ref,
  year,
) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getMonthlyTotals(year);
});
