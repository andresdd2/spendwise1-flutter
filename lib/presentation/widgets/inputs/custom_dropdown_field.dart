import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hintText; // lo mantenemos por compatibilidad
  final String? errorMessage;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    this.label,
    this.hintText,
    this.errorMessage,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(15));
    final textStyle = TextStyle(color: AppPalette.grisClaro);

    // 1) Asegurar el mismo estilo para menú y seleccionado
    final effectiveItems = items.map((e) {
      return DropdownMenuItem<T>(
        value: e.value,
        child: DefaultTextStyle.merge(style: textStyle, child: e.child),
      );
    }).toList();

    return DropdownButtonFormField<T>(
      value: value,
      items: effectiveItems,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
      style: textStyle,

      selectedItemBuilder: (context) {
        return effectiveItems.map((e) {
          return DefaultTextStyle.merge(style: textStyle, child: e.child);
        }).toList();
      },

      dropdownColor: AppPalette.cComponent3,
      icon: Icon(Icons.arrow_drop_down, color: AppPalette.grisClaro),

      hint: hintText != null ? Text(hintText!, style: textStyle) : null,

      decoration: InputDecoration(
        enabledBorder: border.copyWith(
          borderSide: BorderSide(color: AppPalette.grisClaro),
        ),
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: AppPalette.grisClaro),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),

        label: label != null ? Text(label!) : null,
        labelStyle: TextStyle(
          color: AppPalette.grisClaro,
          fontWeight: FontWeight.bold,
        ),
        floatingLabelStyle: TextStyle(
          color: AppPalette.grisClaro,
          fontWeight: FontWeight.bold,
        ),

        hintText: null,

        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        filled: true,
        fillColor: AppPalette.cComponent3,
        errorText: errorMessage,
      ),
    );
  }
}

