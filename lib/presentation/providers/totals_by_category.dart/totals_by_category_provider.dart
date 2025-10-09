import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/entity/totals_by_category.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';

final totalsByCategoryProvider = FutureProvider.autoDispose
    .family<List<TotalsByCategory>, ({int year, int month})>((
      ref,
      params,
    ) async {
      final repository = ref.watch(transactionRepositoryProvider);
      return await repository.getTotalsByCategory(params.year, params.month);
    });
