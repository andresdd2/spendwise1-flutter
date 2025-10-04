import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/utils/formatters.dart';

class TotalsTransactionCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const TotalsTransactionCard({
    super.key, 
    required this.amount, 
    required this.color, 
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 20, right: 6, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.cComponent2,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: Offset(0, 6),
              color: Colors.black26
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child: Column(
            children: [
              Text(
                title.toUpperCase(), 
                style: TextStyle(color: AppPalette.cText, fontSize: 17, fontWeight: FontWeight.w600)
              ),
              Text(
                formatToCOP(amount), 
                style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w600)
              )
            ],
          ),
        ),
      ),
    );
  }
}