import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/widgets/forms/custom_transaction_form.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.cBackground,
        title: Text(
          'Transacción',
          style: TextStyle(
            color: AppPalette.cText,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTransactionForm()
          ],
        ),
      ),
    );
  }
}