import 'package:flutter/material.dart';
import 'package:spendwise_1/presentation/widgets/forms/custom_transaction_form.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTransactionForm()
        ],
      ),
    );
  }
}