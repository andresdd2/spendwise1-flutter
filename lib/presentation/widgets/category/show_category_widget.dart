import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/utils/string_extensions.dart';

class ShowCategoryWidget extends StatelessWidget {
  final String id;
  final String name;

  const ShowCategoryWidget({super.key, required this.id, required this.name});

  IconData _getCategoryIcon(String categoryName) {
    final lowerName = categoryName.toLowerCase();

    if (lowerName.contains('entretenimiento')) {
      return Icons.movie_rounded;
    } else if (lowerName.contains('salud') ||
        lowerName.contains('medicamento')) {
      return Icons.medical_services_rounded;
    } else if (lowerName.contains('servicio')) {
      return Icons.build_rounded;
    } else if (lowerName.contains('freelance')) {
      return Icons.laptop_mac_rounded;
    } else {
      return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 2, right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.cComponent4,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3)
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getCategoryIcon(name), color: AppPalette.cAccent, size: 18),
              const SizedBox(width: 25),
              Flexible(
                child: Text(
                  name.capitalizeFirst(),
                  style: TextStyle(
                    color: AppPalette.cText,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}