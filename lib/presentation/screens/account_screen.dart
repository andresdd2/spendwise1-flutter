import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.cBackground,
        title: const Text(
          'Proxima actualización',
          style: TextStyle(
            color: AppPalette.cText,
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: false,
      ),
    );
  }
}