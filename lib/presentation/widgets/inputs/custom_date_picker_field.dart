import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';

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
                        colorScheme: ColorScheme.dark(
                          primary: AppPalette
                              .cAccent, // Color principal (header y selección)
                          onPrimary: AppPalette
                              .cText, // Texto sobre el color principal
                          surface:
                              AppPalette.cComponent, // Fondo del calendario
                          onSurface: AppPalette.cText, // Texto de los días
                          background:
                              AppPalette.cBackground, // Fondo del diálogo
                          onBackground:
                              AppPalette.cText, // Texto sobre el fondo
                        ),
                        dialogBackgroundColor: AppPalette.cComponent,
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                AppPalette.cAccent, // Color de los botones
                          ),
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
                  labelStyle: TextStyle(color: AppPalette.grisClaro),
                  hintText: hintText,
                  hintStyle: TextStyle(color: AppPalette.grisClaro),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: AppPalette.cComponent3,
                  errorText: errorMessage ?? state.errorText,
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: AppPalette.grisClaro,
                  ),
                ),
                child: Text(
                  selectedDate != null
                      ? _formatDate(selectedDate!)
                      : hintText ?? '',
                  style: TextStyle(
                    color: selectedDate != null
                        ? AppPalette.grisClaro
                        : Colors.grey,
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
