import 'package:spendwise_1/domain/entity/transaction.dart';

class TransactionsState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? errorMessage;

  TransactionsState({
    this.transactions = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TransactionsState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
