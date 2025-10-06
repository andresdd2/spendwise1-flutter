class TotalsByCategory {
  final String categoryId;
  final String categoryName;
  final double totalIncome;
  final double totalExpense;
  final int incomeCount;
  final int expenseCount;

  TotalsByCategory({
    required this.categoryId,
    required this.categoryName,
    required this.totalIncome,
    required this.totalExpense,
    required this.incomeCount,
    required this.expenseCount,
  });
}
