import 'package:intl/intl.dart';

String formatToCOP(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
    customPattern: '\u00A4#,##0'
  );
  return formatter.format(amount);
}

String formatDate(DateTime date) {
  final formatter = DateFormat('d MMM yyyy', 'es');
  return formatter.format(date);
}