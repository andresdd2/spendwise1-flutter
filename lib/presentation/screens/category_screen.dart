import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/category/category_provider.dart';
import 'package:spendwise_1/presentation/providers/totals_by_category.dart/totals_by_category_provider.dart';
import 'package:spendwise_1/presentation/widgets/category/category_pie_chart.dart';
import 'package:spendwise_1/presentation/widgets/category/show_category_widget.dart';
import 'package:spendwise_1/presentation/widgets/category/totals_by_category.dart';
import 'package:spendwise_1/utils/app_date_utils.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = AppDateUtils.getCurrentYear();
    final month = AppDateUtils.getCurrentMonth();

    final categoriesAsync = ref.watch(categoriesProvider);
    final totalsByCategoryAsync = ref.watch(
      totalsByCategoryProvider((year: year, month: month)),
    );

    final isLoading =
        categoriesAsync.isLoading || totalsByCategoryAsync.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.cBackground,
        surfaceTintColor: AppPalette.cBackground,
        title: Text(
          'Categorías',
          style: TextStyle(
            color: AppPalette.cText,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: false,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppPalette.cAccent),
            )
          : CustomScrollView(
              slivers: [
                
                categoriesAsync.when(
                  data: (categories) {
                    if (categories.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No hay categorías disponibles',
                              style: TextStyle(
                                color: AppPalette.cText,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 2,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final category = categories[index];
                          return ShowCategoryWidget(
                            id: category.id,
                            name: category.name,
                          );
                        }, childCount: categories.length),
                      ),
                    );
                  },
                  error: (error, stack) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error al cargar categorías: $error',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  loading: () =>
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                totalsByCategoryAsync.when(
                  data: (totals) {
                    if (totals.isEmpty) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          
                          children: [

                            // Gráfico de gastos
                            const Text(
                              'Distribución de Gastos',
                              style: TextStyle(
                                color: AppPalette.cText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            CategoryPieChart(data: totals, showExpenses: true),
                            const SizedBox(height: 50),

                            // Gráfico de ingresos
                            const Text(
                              'Distribución de Ingresos',
                              style: TextStyle(
                                color: AppPalette.cText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            CategoryPieChart(data: totals, showExpenses: false),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (error, stack) =>
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 10),
                    child: Text(
                      'Detalle por categorías',
                      style: TextStyle(
                        color: AppPalette.cText,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                totalsByCategoryAsync.when(
                  data: (totals) {
                    if (totals.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'No hay datos para mostrar',
                            style: TextStyle(color: AppPalette.cText),
                          ),
                        ),
                      );
                    }
                    return SliverList.builder(
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
                  loading: () =>
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (error, stack) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error al cargar totales: $error',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
              ],
            ),
    );
  }
}
