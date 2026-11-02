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
          'title': 'Administrator Utama',
          'roleName': 'Admin Utama',
          'description': 'Pengelola layanan eLingk',
          'icon': Icons.admin_panel_settings_rounded,
          'greeting': 'Pusat Kendali eLingk',
        };

      case 'unit_admin':
      case 'admin_unit':
        return {
          'title': 'Administrator Unit',
          'roleName': 'Admin Unit',
          'description': 'Pengelola pengaduan unit',
          'icon': Icons.business_rounded,
          'greeting': 'Dashboard Unit',
        };

      case 'field_officer':
      case 'petugas_lapangan':
        return {
          'title': 'Petugas Lapangan',
          'roleName': 'Petugas Lapangan',
          'description': 'Penanganan pengaduan lapangan',
          'icon': Icons.engineering_rounded,
          'greeting': 'Dashboard Petugas',
        };

      default:
        return {
          'title': 'Pengguna eLingk',
          'roleName': 'Pengguna',
          'description': 'Layanan pengaduan eLingk',
          'icon': Icons.account_circle_rounded,
          'greeting': 'Selamat datang',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = roleConfig;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.blueDark, AppColors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: -55,
            child: Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 35,
            bottom: -80,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Icon(
                      config['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'eLingk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          config['title'] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Get.to(
                          () => SharedProfileView(
                            roleName: config['roleName'] as String,
                            description: config['description'] as String,
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(11),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 27),
              Text(
                config['greeting'] as String,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Selamat datang kembali! 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Kelola layanan dan pantau pengaduan masyarakat '
                'melalui satu dashboard.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
