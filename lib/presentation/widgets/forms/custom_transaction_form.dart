import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/presentation/providers/category/category_provider.dart';
import 'package:spendwise_1/presentation/providers/daily_totals/daily_totals_provider.dart';
import 'package:spendwise_1/presentation/providers/monthly_totals/monthly_totals.dart';
import 'package:spendwise_1/presentation/providers/totals_by_category.dart/totals_by_category_provider.dart';
import 'package:spendwise_1/presentation/providers/totals_transaction/totals_provider.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_currency_field.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_date_picker_field.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_dropdown_field.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_text_area_field.dart';
import 'package:spendwise_1/utils/currency_input_formatter.dart';

class CustomTransactionForm extends ConsumerStatefulWidget {
  final Transaction? transactionToEdit;

  const CustomTransactionForm({super.key, this.transactionToEdit});

  @override
  ConsumerState<CustomTransactionForm> createState() =>
      _CustomTransactionFormState();
}

class _CustomTransactionFormState extends ConsumerState<CustomTransactionForm> {
  String? selectedCategoryId;
  DateTime? selectedDate;
  DateTime? originalDate;
  double? amount;
  String? selectedType;
  String description = '';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      _initializeEditMode();
    }
  }

  void _initializeEditMode() {
    final transaction = widget.transactionToEdit!;
    selectedCategoryId = transaction.category.id;
    selectedDate = transaction.date;
    amount = transaction.amount;
    selectedType = transaction.type;
    description = transaction.description;

    originalDate = transaction.date;

    _amountController.text = formatCurrencyValue(transaction.amount);
    _descriptionController.text = transaction.description;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.transactionToEdit != null;

  void _resetForm() {
    _formKey.currentState!.reset();
    _amountController.clear();
    _descriptionController.clear();
    setState(() {
      selectedCategoryId = null;
      selectedDate = null;
      amount = null;
      selectedType = null;
      description = '';
    });
  }

  Future<void> _invalidateProviders(int year, int month, Transaction transaction) async {
    ref.refresh(totalsProvider((year, month)));
    ref.refresh(dailyTotalsProvider((year: year, month: month)));
    ref.refresh(totalsByCategoryProvider((year: year, month: month)));
    ref.refresh(monthlyTotalsProvider(year));

    await ref
        .read(transactionsProvider.notifier)
        .loadTransactions();
    ref.refresh(transactionsProvider);

    if (transaction.id.isNotEmpty) {
      ref.refresh(transactionByIdProvider(transaction.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomCurrencyField(
              label: 'Monto',
              hintText: 'Ingresa el monto',
              controller: _amountController,
              onChanged: (value) {
                amount = parseCurrencyValue(value ?? '0');
              },
              validator: (value) {
                final stringValue = value as String?;
                if (stringValue == null || stringValue.isEmpty) {
                  return 'El monto es requerido';
                }
                final parsed = parseCurrencyValue(stringValue);
                if (parsed <= 0) {
                  return 'El monto debe ser mayor a 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextAreaField(
              label: 'Descripción',
              hintText: 'Escribe una descripción detallada...',
              maxLines: 5,
              maxLength: 500,
              controller: _descriptionController,
              onChanged: (value) => description = value ?? '',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción es requerida';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            categoriesAsync.when(
              data: (categories) => CustomDropdownField<String>(
                label: 'Categoría',
                hintText: 'Selecciona una categoría',
                value: selectedCategoryId,
                items: categories
                    .map(
                      (cat) => DropdownMenuItem<String>(
                        value: cat.id,
                        child: Text(cat.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error cargando categorías: $err'),
            ),
            const SizedBox(height: 20),
            CustomDatePickerField(
              label: 'Fecha',
              hintText: 'Selecciona una fecha',
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'La fecha es requerida';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomDropdownField<String>(
              label: 'Tipo',
              hintText: 'Gasto o Ingreso',
              value: selectedType,
              items: const [
                DropdownMenuItem(value: 'income', child: Text('Ingreso')),
                DropdownMenuItem(value: 'expense', child: Text('Gasto')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona un tipo';
                }
                return null;
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final categories = ref
                        .read(categoriesProvider)
                        .maybeWhen(data: (data) => data, orElse: () => []);
                    final category = categories.firstWhere(
                      (cat) => cat.id == selectedCategoryId,
                    );

                    final transaction = Transaction(
                      id: isEditMode ? widget.transactionToEdit!.id : '',
                      amount: amount!,
                      description: description,
                      date: selectedDate!,
                      category: category,
                      type: selectedType!,
                    );

                    try {
                      final message = isEditMode
                          ? await ref
                                .read(transactionsProvider.notifier)
                                .updateTransaction(transaction.id, transaction)
                          : await ref
                                .read(transactionsProvider.notifier)
                                .addTransaction(transaction);

                      if (!context.mounted) return;

                      final year = selectedDate!.year;
                      final month = selectedDate!.month;
                      await _invalidateProviders(year, month, transaction);

                      if (isEditMode && originalDate != null) {
                        final origYear = originalDate!.year;
                        final origMonth = originalDate!.month;

                        if (origYear != year || origMonth != month) {
                          await _invalidateProviders(origYear, origMonth, transaction);
                        }

                        if (origYear != year) {
                          ref.refresh(
                            monthlyTotalsProvider(origYear),
                          ); // Cambia a refresh
                        }
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: AppPalette.cAccent,
                        ),
                      );

                      // Cambia el manejo post-submit
                      Navigator.of(context).pop();
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.cAccent,
                  foregroundColor: AppPalette.cText,
                ),
                child: Text(
                  isEditMode ? 'Actualizar' : 'Registrar',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
