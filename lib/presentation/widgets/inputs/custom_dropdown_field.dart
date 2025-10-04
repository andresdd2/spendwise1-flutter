import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
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

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Colors.white,
      style: TextStyle(color: Colors.black),
      icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
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
        isDense: true,
        focusColor: Colors.blueAccent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.white60,
        errorText: errorMessage,
      ),
    );
  }
}
