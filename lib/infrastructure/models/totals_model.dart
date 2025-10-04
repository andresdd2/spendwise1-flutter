class TotalsModel {
  final double income;
  final double expense;

  TotalsModel({required this.income, required this.expense});

  factory TotalsModel.fromJson(Map<String, dynamic> json) {
    return TotalsModel(
      income: (json['income'] as num).toDouble(), 
      expense: (json['expense'] as num).toDouble()
    );
  }
}