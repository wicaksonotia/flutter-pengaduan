import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/views/admin_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.admin_panel_settings_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'eLingk',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Panel Admin Utama',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Profil',
          onPressed: () {
            Get.to(
              () => const AdminProfileView(
                roleName: 'Admin Utama',
                description: 'Pengelola layanan eLingk',
              ),
            );
          },
          icon: const Icon(
            Icons.account_circle_outlined,
            color: AppColors.navy,
            size: 29,
          ),
        ),
      ],
    );
  }
}
