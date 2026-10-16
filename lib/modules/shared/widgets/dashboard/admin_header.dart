import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/views/shared_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key, required this.roleCode});

  final String roleCode;

  Map<String, dynamic> get roleConfig {
    switch (roleCode.toLowerCase()) {
      case 'main_admin':
      case 'admin_utama':
        return {
          'title': 'Panel Admin Utama',
          'roleName': 'Admin Utama',
          'description': 'Pengelola layanan eLingk',
          'icon': Icons.admin_panel_settings_rounded,
        };

      case 'unit_admin':
      case 'admin_unit':
        return {
          'title': 'Panel Admin Unit',
          'roleName': 'Admin Unit',
          'description': 'Pengelola pengaduan unit',
          'icon': Icons.business_rounded,
        };

      case 'field_officer':
      case 'petugas_lapangan':
        return {
          'title': 'Panel Petugas Lapangan',
          'roleName': 'Petugas Lapangan',
          'description': 'Penanganan pengaduan lapangan',
          'icon': Icons.engineering_rounded,
        };

      default:
        return {
          'title': 'Panel eLingk',
          'roleName': 'Pengguna',
          'description': 'Layanan pengaduan eLingk',
          'icon': Icons.account_circle_rounded,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = roleConfig;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            config['icon'] as IconData,
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'eLingk',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                config['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Profil',
          onPressed: () {
            Get.to(
              () => SharedProfileView(
                roleName: config['roleName'] as String,
                description: config['description'] as String,
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
