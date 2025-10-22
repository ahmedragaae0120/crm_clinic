import 'dart:developer';

import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final Function(String value) onSearch;
  const SearchWidget({super.key, required this.onSearch});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextField(
        expands: false,
        controller: _controller,
        onChanged: (value) {
          widget.onSearch(value);
          log('value: $value');
        },
        decoration: InputDecoration(
          labelText: AppStrings.searchByNameOrPhone,
          hintText: AppStrings.enterPatientDetails,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              widget.onSearch('');
              FocusScope.of(context).unfocus();
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
