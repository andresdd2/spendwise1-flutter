import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppPalette.cBackground,
        backgroundColor: AppPalette.cBackground,
        title: Text(
          'Mi Cuenta',
          style: TextStyle(
            color: AppPalette.cText,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: AppPalette.cAccent.withAlpha(2),
              child: Icon(Icons.person, size: 50, color: AppPalette.cAccent),
            ),
            const SizedBox(height: 16),
            Text(
              authState.userEmail ?? 'Usuario',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppPalette.cText,
              ),
            ),
            const SizedBox(height: 32),

            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppPalette.cComponent3,
                      title: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: AppPalette.cText,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      content: const Text(
                        '¿Estás seguro que deseas cerrar sesión?',
                        style: TextStyle(
                          color: AppPalette.cText,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: AppPalette.cText,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Cerrar Sesión',
                            style: TextStyle(
                              color: AppPalette.cAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/onboarding');
                    }
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppPalette.cAccent),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppPalette.cText,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppPalette.cText.withAlpha(5),
        ),
        onTap: onTap,
      ),
    );
  }
}
