import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.phone,
    required this.initials,
    required this.isSaving,
    required this.onEdit,
  });

  final String name;
  final String phone;
  final String initials;
  final bool isSaving;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 39,
            backgroundColor: AppColors.white.withValues(alpha: 0.18),
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            phone.isEmpty ? 'Nomor HP belum tersedia' : phone,
            style: TextStyle(
              color: AppColors.textOnPrimary.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isSaving ? null : onEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textOnPrimary,
                disabledForegroundColor: AppColors.textOnPrimary.withValues(
                  alpha: 0.5,
                ),
                side: BorderSide(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.65),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Profil'),
            ),
          ),
        ],
      ),
    );
  }
}
