import 'package:spendwise_1/domain/entity/totals.dart';

class TotalsState {
  final Totals? totals;
  final bool isLoading;
  final String? errorMessage;

  TotalsState({this.totals, this.isLoading = false, this.errorMessage});

  TotalsState copyWith({
    Totals? totals,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TotalsState(
      totals: totals ?? this.totals,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
