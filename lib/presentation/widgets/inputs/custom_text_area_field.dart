import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';

class CustomTextAreaField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorMessage;
  final String? initialValue;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;

  const CustomTextAreaField({
    super.key,
    this.label,
    this.hintText,
    this.errorMessage,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.maxLines = 5,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(15));

    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      maxLines: maxLines,
      maxLength: maxLength,
      style: TextStyle(color: AppPalette.grisClaro),
      cursorColor: AppPalette.grisClaro,
      decoration: InputDecoration(
        enabledBorder: border.copyWith(
          borderSide: BorderSide(color:   AppPalette.grisClaro),
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
        labelStyle: TextStyle(color: AppPalette.grisClaro),
        hintText: hintText,
        hintStyle: TextStyle(color: AppPalette.grisClaro),
        focusColor: AppPalette.cComponent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        filled: true,
        fillColor: AppPalette.cComponent3,
        errorText: errorMessage,
        alignLabelWithHint: true,
      ),
    );
  }
}
