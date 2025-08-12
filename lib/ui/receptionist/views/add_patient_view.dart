import 'package:crm_clinic/core/reusable_comp/validator.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Gender {
  male("Male"),
  female("Female");

  final String name;
  const Gender(this.name);
}

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
  DateTime? _selectedDate;
  Gender? _selectedGender;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _selectedDate ?? DateTime(now.year - 20);
    final first = DateTime(1900);
    final last = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: "Select Birth Date",
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  addPatient() {
    if (_formKey.currentState?.validate() ?? false) {
      print("Patient added successfully");
    } else {
      print("Validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config().init(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Form to add a new patient will go here.',
                style: theme.textTheme.headlineLarge,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Full name",
              ),
              controller: _nameController,
              validator: Validator.name,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "phone number",
              ),
              keyboardType: TextInputType.phone,
              validator: Validator.phoneNumber,
              controller: _phoneController,
            ),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                // prevent keyboard, make readonly
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: "birth date",
                    suffixIcon: Icon(Icons.calendar_month_outlined,
                        color: theme.primaryColor),
                  ),
                  validator: Validator.date,
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _selectedGender,
              validator: (value) => Validator.dropdownButton(value),
              items: Gender.values
                  .map((gender) =>
                      DropdownMenuItem(value: gender, child: Text(gender.name)))
                  .toList(),
              decoration: InputDecoration(
                hintText: "Select Gender",
              ),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            Config.spaceMedium,
            ElevatedButton(
                onPressed: addPatient, child: const Text('Add Patient'))
          ],
        ),
      ),
    );
  }
}
