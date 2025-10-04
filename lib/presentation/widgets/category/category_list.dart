import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/category/category_provider.dart';
import 'package:spendwise_1/presentation/widgets/category/show_category_widget.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(
            child: Text(
              'No hay categorías disponibles',
              style: TextStyle(
                color: AppPalette.cText,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 2,
            ),
            itemCount: categories.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final category = categories[index];
              return ShowCategoryWidget(id: category.id, name: category.name);
            },
          );
        }
      },
      error: (error, stack) => Center(child: Text('Error: $error')),
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppPalette.cAccent),
      ),
    );
  }
}
