class DailyTotalsModel {
  final int day;
  final double income;
  final double expense;

  DailyTotalsModel({
    required this.day,
    required this.income,
    required this.expense,
  });

  factory DailyTotalsModel.fromJson(Map<String, dynamic> json) {
    return DailyTotalsModel(
      day: json['day'] as int,
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
    );
  }
}