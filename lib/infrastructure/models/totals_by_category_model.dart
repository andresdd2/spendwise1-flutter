class TotalsByCategoryModel {
  final String categoryId;
  final String categoryName;
  final double totalIncome;
  final double totalExpense;
  final int incomeCount;
  final int expenseCount;

  TotalsByCategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.totalIncome,
    required this.totalExpense,
    required this.incomeCount,
    required this.expenseCount,
  });

  factory TotalsByCategoryModel.fromJson(Map<String, dynamic> json) {
    return TotalsByCategoryModel(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      incomeCount: json['incomeCount'] as int,
      expenseCount: json['expenseCount'] as int,
    );
  }
}
