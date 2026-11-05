import 'package:sapahub/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileLogoutButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const ProfileLogoutButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.danger,
                ),
              )
            : const Icon(Icons.logout_rounded),
        label: Text(
          isLoading ? 'Sedang keluar...' : 'Keluar dari Akun',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: BorderSide(color: AppColors.danger.withValues(alpha: 0.45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
