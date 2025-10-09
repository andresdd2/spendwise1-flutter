import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';
import 'package:spendwise_1/utils/formatters.dart';

class TransactionDetail extends ConsumerWidget {
  final Transaction transaction;

  const TransactionDetail({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIncome = transaction.type == 'income';

    return Scaffold(
      backgroundColor: AppPalette.cBackground,
      appBar: AppBar(
        backgroundColor: AppPalette.cBackground,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppPalette.cText),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono circular
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isIncome
                        ? AppPalette.cAccent.withOpacity(0.15)
                        : Colors.redAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 40,
                    color: isIncome ? AppPalette.cAccent : Colors.redAccent,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Descripción
              Center(
                child: Text(
                  transaction.description,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.cText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Monto
              Center(
                child: Text(
                  formatToCOP(transaction.amount),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? AppPalette.cAccent : Colors.redAccent,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Fecha
              Center(
                child: Text(
                  formatDate(transaction.date),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppPalette.cText.withOpacity(0.7),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Tipo (chip)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isIncome
                        ? AppPalette.cAccent.withOpacity(0.15)
                        : Colors.redAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isIncome ? 'Ingreso' : 'Gasto',
                    style: TextStyle(
                      color: isIncome ? AppPalette.cAccent : Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Detalles adicionales
              _DetailRow(label: 'Categoría', value: transaction.category.name),

              const SizedBox(height: 16),

              _DetailRow(label: 'ID', value: transaction.id),

              const SizedBox(height: 40),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implementar actualización
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Función de actualizar en desarrollo',
                            ),
                            backgroundColor: AppPalette.cAccent,
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Actualizar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppPalette.cAccent,
                        side: BorderSide(color: AppPalette.cAccent, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final confirm = await _showDeleteDialog(context);
                        if (confirm == true) {
                          try {
                            await ref
                                .read(transactionsProvider.notifier)
                                .deleteTransaction(transaction.id);

                            if (context.mounted) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Transacción eliminada'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al eliminar: $e'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Eliminar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppPalette.cBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '¿Eliminar transacción?',
          style: TextStyle(
            color: AppPalette.cText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Esta acción no se puede deshacer.',
          style: TextStyle(color: AppPalette.cText.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar', style: TextStyle(color: AppPalette.cText)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.cBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppPalette.cText.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppPalette.cText.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppPalette.cText,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
