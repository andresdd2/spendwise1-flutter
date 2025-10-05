import 'package:spendwise_1/infrastructure/models/category_model.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final CategoryModel category;
  final String type;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'category': category.toJson(),
      'type': type,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'amount': amount.toStringAsFixed(0),
      'description': description,
      'date': date.toIso8601String().split(
        'T',
      )[0],
      'category': category.id,
      'type': type,
    };
  }
}
