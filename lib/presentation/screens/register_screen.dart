import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/presentation/widgets/forms/custom_transaction_form.dart';

class RegisterScreen extends StatelessWidget {
  final Transaction? transactionToEdit;

  const RegisterScreen({super.key, this.transactionToEdit});

  @override
  Widget build(BuildContext context) {
    final isEditMode = transactionToEdit != null;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppPalette.cText),
        backgroundColor: AppPalette.cBackground,
        title: Text(
          isEditMode ? 'Editar Transacción' : 'Registrar Transacción',
          style: TextStyle(color: AppPalette.cText),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTransactionForm(transactionToEdit: transactionToEdit),
          ],
        ),
      ),
    );
  }
}