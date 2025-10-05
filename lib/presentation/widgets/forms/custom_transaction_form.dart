import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/presentation/providers/category/category_provider.dart';
import 'package:spendwise_1/presentation/providers/totals_transaction/totals_provider.dart';
import 'package:spendwise_1/presentation/providers/transaction/transaction_provider.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_currency_field.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_date_picker_field.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_dropdown_field.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_text_area_field.dart';
import 'package:spendwise_1/utils/currency_input_formatter.dart';

class CustomTransactionForm extends ConsumerStatefulWidget {
  const CustomTransactionForm({super.key});

  @override
  ConsumerState<CustomTransactionForm> createState() =>
      _CustomTransactionFormState();
}

class _CustomTransactionFormState extends ConsumerState<CustomTransactionForm> {
  String? selectedCategoryId;
  DateTime? selectedDate;
  double? amount;
  String? selectedType;
  String description = '';
  final _formKey = GlobalKey<FormState>();

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
              
                    final newTransaction = Transaction(
                      id: '',
                      amount: amount!,
                      description: description,
                      date: selectedDate!,
                      category: category,
                      type: selectedType!,
                    );
              
                    try {
                      final message = await ref
                          .read(transactionsProvider.notifier)
                          .addTransaction(newTransaction);
              
                      if (!context.mounted) return;
              
                      final year = selectedDate!.year;
                      final month = selectedDate!.month;
                      ref.invalidate(totalsProvider((year, month)));
              
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
              
                      _formKey.currentState!.reset();
                      setState(() {
                        selectedCategoryId = null;
                        selectedDate = null;
                        amount = null;
                        selectedType = null;
                        description = '';
                      });
                    } catch (e) {
                      if (!context.mounted) return;
              
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.cAccent,
                  foregroundColor: AppPalette.cText,
                ),
                child: const Text('Registrar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}