import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/widgets/forms/custom_signup_form.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppPalette.cBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppPalette.cText),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'SPENDWISE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.cText,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.cText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Comienza a administrar tus finanzas',
                style: TextStyle(
                  fontSize: 16,
                  color: AppPalette.cText.withAlpha(6),
                ),
              ),
              const SizedBox(height: 13),

              const CustomSignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}