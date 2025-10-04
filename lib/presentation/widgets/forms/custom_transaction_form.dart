import 'package:flutter/material.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_date_picker_field.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_dropdown_field.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_text_area_field.dart';

class CustomTransactionForm extends StatefulWidget {
  const CustomTransactionForm({super.key});

  @override
  State<CustomTransactionForm> createState() => _CustomTransactionForm();
}

class _CustomTransactionForm extends State<CustomTransactionForm> {
  String? selectedCategory;
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Fields Example')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              CustomTextAreaField(
                label: 'Descripción',
                hintText: 'Escribe una descripción detallada...',
                maxLines: 5,
                maxLength: 500,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomDropdownField<String>(
                label: 'Categoría',
                hintText: 'Selecciona una categoría',
                value: selectedCategory,
                items: [
                  DropdownMenuItem(value: 'cat1', child: Text('Categoría 1')),
                  DropdownMenuItem(value: 'cat2', child: Text('Categoría 2')),
                  DropdownMenuItem(value: 'cat3', child: Text('Categoría 3')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomDatePickerField(
                label: 'Fecha',
                hintText: 'Selecciona una fecha',
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'La fecha es requerida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Formulario válido')),
                    );
                  }
                },
                child: Text('Validar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
