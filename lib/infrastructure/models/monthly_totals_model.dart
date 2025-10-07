class MonthlyTotalsModel {
  final int month;
  final double income;
  final double expense;

  MonthlyTotalsModel({
    required this.month,
    required this.income,
    required this.expense,
  });

  factory MonthlyTotalsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyTotalsModel(
      month: json['month'] as int,
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
    );
  }
}