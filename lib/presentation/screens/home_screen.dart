import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';
import 'package:spendwise_1/presentation/widgets/transaction/totals_transaction_card.dart';
import 'package:spendwise_1/utils/app_date_utils.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = AppDateUtils.getCurrentYear();
    final month = AppDateUtils.getCurrentMonth();

    final totalsLoading = ref.watch(
      totalsProvider((year, month)).select((a) => a.isLoading),
    );
    final txLoading = ref.watch(
      transactionsProvider.select((a) => a.isLoading),
    );
    final isLoading = totalsLoading || txLoading;

    final totalsHasError = ref.watch(
      totalsProvider((year, month)).select((a) => a.hasError),
    );
    final txHasError = ref.watch(
      transactionsProvider.select((a) => a.hasError),
    );
    final hasError = totalsHasError || txHasError;

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
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),


      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _TotalsRow(year: year, month: month),
              ),

              if (hasError)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Ocurrió un error cargando datos'),
                  ),
                ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
            ],
          ),

          if (isLoading)
            const Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: CircularProgressIndicator(color: AppPalette.cAccent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TotalsRow extends ConsumerWidget {
  const _TotalsRow({required this.year, required this.month});
  final int year;
  final int month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = ref.watch(totalsProvider((year, month))).value;
    if (totals == null)
      return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: TotalsTransactionCard(
            amount: totals.income,
            color: AppPalette.cAccent,
            title: 'income',
          ),
        ),
        Expanded(
          child: TotalsTransactionCard(
            amount: totals.expense,
            color: Colors.redAccent,
            title: 'expense',
          ),
        ),
      ],
    );
  }
}
