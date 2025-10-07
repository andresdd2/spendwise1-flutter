import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';
import 'package:spendwise_1/presentation/widgets/shared/transaction_item.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionsProvider);

    if (transactionsState.transactions.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text(
            'No hay transacciones recientes',
            style: TextStyle(color: AppPalette.cText),
          ),
        ),
      );
    }

    return SliverList.separated(
      itemCount: transactionsState.transactions.length,
      itemBuilder: (context, index) {
        final t = transactionsState.transactions[index];
        return TransactionItem(transaction: t);
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}
