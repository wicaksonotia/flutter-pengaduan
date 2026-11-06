import 'package:flutter/material.dart';

import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/admin_utama/controllers/admin_utama_units_controller.dart';

class UnitsSearchField extends StatefulWidget {
  const UnitsSearchField({super.key, required this.controller});

  final AdminUtamaUnitsController controller;

  @override
  State<UnitsSearchField> createState() => _UnitsSearchFieldState();
}

class _UnitsSearchFieldState extends State<UnitsSearchField> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(
      text: widget.controller.searchQuery.value,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _search(String value) {
    widget.controller.search(value);
  }

  void _clearSearch() {
    searchController.clear();
    _search('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      textInputAction: TextInputAction.search,
      onSubmitted: _search,
      decoration: InputDecoration(
        hintText: 'Cari kode atau nama unit...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: _clearSearch,
          icon: const Icon(Icons.close),
          tooltip: 'Hapus pencarian',
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blue),
        ),
      ),
    );
  }
}
