import 'package:spendwise_1/domain/entity/category.dart';

class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final Category category;
  final String type;

  Transaction({
    required this.id, 
    required this.amount, 
    required this.description, 
    required this.date, 
    required this.category, 
    required this.type
  });
}