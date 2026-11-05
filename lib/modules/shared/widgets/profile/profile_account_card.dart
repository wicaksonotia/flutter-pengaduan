import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/shared/models/shared_profile_model.dart';
import 'package:flutter/material.dart';

class ProfileAccountCard extends StatelessWidget {
  final SharedProfileModel profile;

  const ProfileAccountCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoItem(
            label: 'Hak Akses',
            value: profile.roleDescription,
            icon: Icons.admin_panel_settings_outlined,
            color: AppColors.textPrimary,
            background: AppColors.textPrimary.withValues(alpha: 0.10),
          ),
          _divider(),
          _infoItem(
            label: 'Email',
            value: profile.email,
            icon: Icons.email_outlined,
            color: const Color(0xFF1685C7),
            background: const Color(0xFF1685C7).withValues(alpha: 0.10),
          ),
          _divider(),
          _infoItem(
            label: 'Nomor HP',
            value: profile.phone,
            icon: Icons.phone_android_outlined,
            color: const Color(0xFF159B78),
            background: const Color(0xFF159B78).withValues(alpha: 0.10),
          ),
        ],
      ),
    );
  }

  Widget _infoItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.border,
        indent: 56,
      ),
    );
  }
}
