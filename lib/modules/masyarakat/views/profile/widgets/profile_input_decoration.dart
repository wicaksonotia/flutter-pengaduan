import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileInputDecoration {
  ProfileInputDecoration._();

  static InputDecoration build({
    required String hintText,
    required IconData icon,
  }) {
    OutlineInputBorder outlineBorder(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.blue),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: outlineBorder(AppColors.border),
      enabledBorder: outlineBorder(AppColors.border),
      focusedBorder: outlineBorder(AppColors.blue, width: 1.5),
      errorBorder: outlineBorder(AppColors.danger),
      focusedErrorBorder: outlineBorder(AppColors.danger, width: 1.5),
    );
  }
}
