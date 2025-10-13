import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/utils/currency_input_formatter.dart';

class CustomCurrencyField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorMessage;
  final Function(String?)?
  onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomCurrencyField({
    super.key,
    this.label,
    this.hintText,
    this.errorMessage,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(15));

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyInputFormatter(),
      ],
      style: const TextStyle(
        color: AppPalette.grisClaro,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: Colors.black,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: border.copyWith(
          borderSide: const BorderSide(color: AppPalette.grisClaro),
        ),
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppPalette.grisClaro, width: 2),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800, width: 2),
        ),
        label: label != null ? Text(label!) : null,
        labelStyle: const TextStyle(color: AppPalette.grisClaro),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        isDense: true,
        focusColor: AppPalette.grisClaro,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        filled: true,
        fillColor: AppPalette.cComponent3,
        errorText: errorMessage,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 8),
          child: Icon(Icons.attach_money, color: AppPalette.grisClaro),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}
