import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
    customPattern: '\u00A4#,##0',
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }
    double value = double.parse(digitsOnly);
    String formatted = _formatter.format(value);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// "$312.000" -> 312000.0
double parseCurrencyValue(String formattedValue) {
  if (formattedValue.isEmpty) return 0.0;
  String digitsOnly = formattedValue.replaceAll(RegExp(r'[^\d]'), '');
  if (digitsOnly.isEmpty) return 0.0;
  return double.parse(digitsOnly);
}

/// 312000.0 -> "$312.000"
String formatCurrencyValue(double amount) {
  final intAmount = amount.toInt();
  final formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
    customPattern: '\u00A4#,##0',
  );
  return formatter.format(intAmount);
}
