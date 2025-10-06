import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/totals_by_category.dart/totals_by_category_provider.dart';
import 'package:spendwise_1/presentation/widgets/category/totals_by_category.dart';
import 'package:spendwise_1/utils/app_date_utils.dart';

class TotalsByCategoryList extends ConsumerWidget {

  const TotalsByCategoryList({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = AppDateUtils.getCurrentYear();
    final month = AppDateUtils.getCurrentMonth();

  
    final totalsByCategoryAsync = ref.watch(
      totalsByCategoryProvider((year: year, month: month)),
    );

    return totalsByCategoryAsync.when(
      data: (totals) {
        if (totals.isEmpty) {
          return Center(
            child: Text(
              'No hay datos para mostrar',
              style: TextStyle(color: AppPalette.cText),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totals.length,
          itemBuilder: (context, index) {
            final total = totals[index];
            return TotalsByCategory(
              categoryName: total.categoryName,
              income: total.totalIncome,
              expense: total.totalExpense,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
