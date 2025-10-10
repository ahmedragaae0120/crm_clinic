import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function(String value) onSearch;
  const SearchWidget({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextField(
        expands: false,
        onChanged: (value) {
          onSearch(value);
        },
        decoration: InputDecoration(
          labelText: AppStrings.searchByNameOrPhone,
          hintText: AppStrings.enterPatientDetails,
          prefixIcon: const Icon(Icons.search),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
