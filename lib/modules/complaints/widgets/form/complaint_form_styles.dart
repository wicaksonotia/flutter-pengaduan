import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ComplaintFormStyles {
  ComplaintFormStyles._();

  static BoxDecoration cardDecoration({double radius = 20}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.1),
          blurRadius: 18,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static InputDecoration inputDecoration({
    String? hint,
    IconData? prefixIcon,
    bool alignTop = false,
  }) {
    OutlineInputBorder makeBorder(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 12,
        height: 1.5,
      ),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: AppColors.textMuted, size: 20),
      prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 48),
      alignLabelWithHint: alignTop,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      counterStyle: const TextStyle(fontSize: 10, color: AppColors.textMuted),
      border: makeBorder(AppColors.border),
      enabledBorder: makeBorder(AppColors.border),
      focusedBorder: makeBorder(AppColors.blue, width: 1.5),
      errorBorder: makeBorder(AppColors.danger),
      focusedErrorBorder: makeBorder(AppColors.danger, width: 1.5),
    );
  }

  static Widget card({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: cardDecoration(),
      child: child,
    );
  }

  static Widget fieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
