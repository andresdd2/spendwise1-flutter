import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/utils/formatters.dart';
import 'package:spendwise_1/utils/string_extensions.dart';

class TotalsByCategory extends StatelessWidget {
  final String categoryName;
  final double income;
  final double expense;

  const TotalsByCategory({
    super.key, 
    required this.categoryName, 
    required this.income, 
    required this.expense
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.cComponent4,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(0, 8),
              color: AppPalette.cComponent2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 7, right: 16, bottom: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  categoryName.capitalizeFirst(), 
                  style: TextStyle(color: AppPalette.cText, fontSize: 17, fontWeight: FontWeight.bold)
                  )
              ),
              Column(
                children: [
                  Text(
                    formatToCOP(income), 
                    style: TextStyle(color: AppPalette.cAccent, fontSize: 17, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatToCOP(expense),
                    style: TextStyle(color: Colors.redAccent, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}