import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';

class NavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  const NavigationBarWidget({
    super.key,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: AppPalette.cBackground,
        indicatorColor: AppPalette.cAccent.withOpacity(0.25),

        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppPalette.cAccent);
          }
          if (states.contains(WidgetState.focused)) {
            return const IconThemeData(color: AppPalette.cAccent);
          }
          return const IconThemeData(color: AppPalette.cText);
        }),

        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? AppPalette.cAccent
              : AppPalette.cText;
          return TextStyle(color: color, fontWeight: FontWeight.w600);
        }),
      ),

      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_max_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_outlined),
            label: 'Transacción',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            label: 'Otros',
          ),
        ],
      ),
    );
  }
}
