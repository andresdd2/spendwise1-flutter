import 'package:flutter/material.dart';

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
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        enabledBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        label: label != null ? Text(label!) : null,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        focusColor: Colors.blueAccent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.white60,
        errorText: errorMessage,
        alignLabelWithHint: true,
      ),
    );
  }
}
