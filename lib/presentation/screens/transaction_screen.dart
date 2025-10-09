import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';
import 'package:spendwise_1/presentation/widgets/shared/transaction_item.dart';
import 'package:spendwise_1/utils/formatters.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    // Esto carga las categorías al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionsProvider.notifier).loadTransactions();
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppPalette.cAccent,
              onPrimary: Colors.white,
              surface: AppPalette.cBackground,
              onSurface: AppPalette.cText,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppPalette.cAccent),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppPalette.cBackground,
              headerBackgroundColor: AppPalette.cAccent,
              headerForegroundColor: Colors.white,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                if (states.contains(WidgetState.disabled)) {
                  return AppPalette.cText;
                }
                return AppPalette.cText;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppPalette.cAccent;
                }
                return Colors.white;
              }),
              todayForegroundColor: WidgetStateProperty.all(AppPalette.cAccent),
              todayBorder: BorderSide(color: AppPalette.cAccent, width: 1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      // Cargar transacciones por rango de fechas
      ref
          .read(transactionsProvider.notifier)
          .loadTransactionsByDateRange(picked.start, picked.end);
    }
  }

  void _clearDateRange() {
    setState(() {
      _selectedDateRange = null;
    });
    // Cargar todas las transacciones
    ref.read(transactionsProvider.notifier).loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppPalette.cBackground,
        backgroundColor: AppPalette.cBackground,
        title: Text(
          'Transacción',
          style: TextStyle(
            color: AppPalette.cText,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            color: AppPalette.cAccent,
            tooltip: 'Agregar',
            onPressed: () => context.push('/register-screen'),
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: transactionsState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppPalette.cAccent),
            )
          : transactionsState.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transactionsState.errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedDateRange != null) {
                        ref
                            .read(transactionsProvider.notifier)
                            .loadTransactionsByDateRange(
                              _selectedDateRange!.start,
                              _selectedDateRange!.end,
                            );
                      } else {
                        ref
                            .read(transactionsProvider.notifier)
                            .loadTransactions();
                      }
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                // DateRangePicker Section
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppPalette.cBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filtrar por fecha',
                          style: TextStyle(
                            color: AppPalette.cText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _selectDateRange,
                                icon: const Icon(Icons.date_range),
                                label: Text(
                                  _selectedDateRange == null
                                      ? 'Seleccionar rango'
                                      : '${formatDate(_selectedDateRange!.start)} - ${formatDate(_selectedDateRange!.end)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppPalette.cAccent,
                                  side: BorderSide(color: AppPalette.cAccent),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            if (_selectedDateRange != null) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _clearDateRange,
                                icon: const Icon(Icons.clear),
                                tooltip: 'Limpiar filtro',
                                color: Colors.redAccent,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Transaction List Widget
                transactionsState.transactions.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: AppPalette.cText.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _selectedDateRange != null
                                    ? 'No hay transacciones en este rango'
                                    : 'No hay transacciones registradas',
                                style: TextStyle(
                                  color: AppPalette.cText.withOpacity(0.6),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList.separated(
                          itemCount: transactionsState.transactions.length,
                          itemBuilder: (context, index) {
                            final t = transactionsState.transactions[index];
                            return TransactionItem(transaction: t);
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                        ),
                      ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
    );
  }
}