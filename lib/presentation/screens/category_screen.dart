import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/widgets/category/category_list.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.cBackground,
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
      body: Column(children: [Expanded(child: CategoryList())]),
    );
  }
}
