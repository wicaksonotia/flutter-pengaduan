import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const AppSearchField({
    super.key,
    required this.onChanged,
    this.hintText = 'Cari...',
  });

  @override
  Widget build(BuildContext context) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 12),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.iconSecondary,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: outline,
        enabledBorder: outline,
        focusedBorder: outline.copyWith(
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }
}
