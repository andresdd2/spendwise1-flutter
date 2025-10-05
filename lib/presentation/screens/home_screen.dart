import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/totals_transaction/totals_provider.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';
import 'package:spendwise_1/presentation/widgets/transaction/totals_transaction_card.dart';
import 'package:spendwise_1/utils/app_date_utils.dart';
import 'package:spendwise_1/utils/formatters.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = AppDateUtils.getCurrentYear();
    final month = AppDateUtils.getCurrentMonth();

    final transactionsState = ref.watch(transactionsProvider);
    final totalsState = ref.watch(totalsProvider((year, month)));

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppPalette.cBackground,
        backgroundColor: AppPalette.cBackground,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, User.',
              style: TextStyle(
                color: AppPalette.cText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Visualiza tus ingresos y gastos',
              style: TextStyle(
                color: AppPalette.cText,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: transactionsState.isLoading || totalsState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppPalette.cAccent),
            )
          : transactionsState.errorMessage != null ||
                totalsState.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transactionsState.errorMessage ??
                        totalsState.errorMessage ??
                        'Error desconocido',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(transactionsProvider.notifier)
                          .loadTransactions();
                      ref
                          .read(totalsProvider((year, month)).notifier)
                          .loadTotals();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: totalsState.totals != null
                      ? Row(
                          children: [
                            Expanded(
                              child: TotalsTransactionCard(
                                amount: totalsState.totals!.income,
                                color: AppPalette.cAccent,
                                title: 'Ingresos',
                              ),
                            ),
                            Expanded(
                              child: TotalsTransactionCard(
                                amount: totalsState.totals!.expense,
                                color: Colors.redAccent,
                                title: 'Gastos',
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 16)),
                if (transactionsState.transactions.isEmpty)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No hay transacciones para este mes',
                        style: TextStyle(color: AppPalette.cText),
                      ),
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: transactionsState.transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactionsState.transactions[index];
                      return ListTile(
                        title: Text(
                          formatToCOP(t.amount),
                          style: TextStyle(
                            color: t.type == 'income'
                                ? AppPalette.cAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          t.description,
                          style: TextStyle(color: AppPalette.cText),
                        ),
                        trailing: Text(
                          formatDate(t.date),
                          style: TextStyle(
                            color: AppPalette.cText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                  ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
              ],
            ),
    );
  }
}
