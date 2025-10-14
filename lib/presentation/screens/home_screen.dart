import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_provider.dart';
import 'package:spendwise_1/presentation/providers/daily_totals/daily_totals_provider.dart';
import 'package:spendwise_1/presentation/providers/monthly_totals/monthly_totals.dart';
import 'package:spendwise_1/presentation/providers/totals_transaction/totals_provider.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';
import 'package:spendwise_1/presentation/widgets/shared/transaction_list.dart';
import 'package:spendwise_1/presentation/widgets/transaction/daily_line_chart.dart';
import 'package:spendwise_1/presentation/widgets/transaction/monthly_bar_chart.dart';
import 'package:spendwise_1/presentation/widgets/transaction/totals_transaction_card.dart';
import 'package:spendwise_1/utils/app_date_utils.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = AppDateUtils.getCurrentYear();
    final month = AppDateUtils.getCurrentMonth();
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (previous?.userEmail != next.userEmail && next.isAuthenticated) {
        Future.microtask(() {
          ref.read(transactionsProvider.notifier).loadTransactions(limit: 10);
          ref.read(totalsProvider((year, month)).notifier).loadTotals();
        });
      }
    });

    final transactionsState = ref.watch(transactionsProvider);
    final totalsState = ref.watch(totalsProvider((year, month)));
    final monthlyTotalsAsync = ref.watch(monthlyTotalsProvider(year));
    final dailyTotalsAsync = ref.watch(
      dailyTotalsProvider((year: year, month: month)),
    );

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppPalette.cBackground,
        backgroundColor: AppPalette.cBackground,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${authState.userEmail ?? 'Usuario'} .',
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
                // Tarjetas de totales del mes actual
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

                // Gráfico de barras mensuales
                SliverToBoxAdapter(
                  child: monthlyTotalsAsync.when(
                    data: (totals) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Resumen Anual',
                              style: TextStyle(
                                color: AppPalette.cText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            MonthlyBarChart(data: totals),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppPalette.cAccent,
                        ),
                      ),
                    ),
                    error: (error, stack) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error al cargar estadísticas: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Gráfico de líneas diarias
                SliverToBoxAdapter(
                  child: dailyTotalsAsync.when(
                    data: (totals) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Movimientos Diarios del Mes',
                              style: TextStyle(
                                color: AppPalette.cText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DailyLineChart(data: totals),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppPalette.cAccent,
                        ),
                      ),
                    ),
                    error: (error, stack) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error al cargar movimientos diarios: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 10),
                    child: Text(
                      'Últimas transacciones del mes',
                      style: TextStyle(
                        color: AppPalette.cText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 2)),

                // Lista de transacciones
                const TransactionList(),
              ],
            ),
    );
  }
}