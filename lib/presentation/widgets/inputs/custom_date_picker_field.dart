import 'package:flutter/material.dart';

class CustomDatePickerField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorMessage;
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePickerField({
    super.key,
    this.label,
    this.hintText,
    this.errorMessage,
    this.selectedDate,
    this.onDateSelected,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(15));

    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: validator,
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: firstDate ?? DateTime(1900),
                  lastDate: lastDate ?? DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  state.didChange(picked);
                  onDateSelected?.call(picked);
                }
              },
              child: InputDecorator(
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
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Colors.white60,
                  errorText: errorMessage ?? state.errorText,
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blueAccent,
                  ),
                ),
                child: Text(
                  selectedDate != null
                      ? _formatDate(selectedDate!)
                      : hintText ?? '',
                  style: TextStyle(
                    color: selectedDate != null ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
