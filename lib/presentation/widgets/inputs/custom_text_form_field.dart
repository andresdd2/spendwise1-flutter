import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorMessage;
  final bool? obscureText;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? enabled;
  final Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.errorMessage,
    this.obscureText,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.enabled,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(15));

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled ?? true,
      style: TextStyle(color: Colors.black),
      cursorColor: AppPalette.cComponent3,
      obscureText: obscureText ?? false,
      initialValue: controller == null ? initialValue : null,
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
        disabledBorder: border.copyWith(
          borderSide: BorderSide(color: AppPalette.grisClaro.withOpacity(0.5)),
        ),
        label: label != null ? Text(label!) : null,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        hintText: hintText,
        hintStyle: TextStyle(color: AppPalette.cComponent3),
        isDense: true,
        focusColor: Colors.blueAccent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        filled: true,
        fillColor: (enabled ?? true)
            ? AppPalette.grisClaro
            : AppPalette.grisClaro.withOpacity(0.5),
        errorText: errorMessage,
        suffixIcon: suffixIcon,
      ),
    );
  }
}