import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/shared/controllers/shared_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  Map<String, dynamic> _getRoleConfig(String roleCode) {
    switch (roleCode.toLowerCase()) {
      case 'main_admin':
      case 'admin_utama':
        return {
          'title': 'Administrator Utama',
          'description': 'Pengelola layanan SIGAP KAWAN',
          'icon': Icons.admin_panel_settings_rounded,
          'greeting': 'Pusat Kendali SIGAP KAWAN',
        };

      case 'unit_admin':
      case 'admin_unit':
        return {
          'title': 'Administrator Unit',
          'description': 'Pengelola pengaduan unit',
          'icon': Icons.business_rounded,
          'greeting': 'Dashboard Unit',
        };

      case 'field_officer':
      case 'petugas_lapangan':
        return {
          'title': 'Petugas Lapangan',
          'description': 'Penanganan pengaduan lapangan',
          'icon': Icons.engineering_rounded,
          'greeting': 'Dashboard Petugas',
        };

      case 'masyarakat':
      case 'user':
        return {
          'title': 'Masyarakat',
          'description': 'Layanan Pengaduan Masyarakat',
          'icon': Icons.people_alt_rounded,
          'greeting': 'Layanan Pengaduan SIGAP KAWAN',
        };

      default:
        return {
          'title': 'Pengguna SIGAP KAWAN',
          'description': 'Layanan pengaduan perhubungan',
          'icon': Icons.account_circle_rounded,
          'greeting': 'Selamat datang',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SharedProfileController>();

    return Obx(() {
      final profile = controller.profile.value;

      if (controller.isLoading.value && profile == null) {
        return _buildLoading();
      }

      if (profile == null) {
        return _buildError(controller);
      }

      final role = profile.primaryRole;
      final roleCode = role?.kode ?? '';
      final config = _getRoleConfig(roleCode);

      final isMasyarakat = [
        'masyarakat',
        'user',
      ].contains(roleCode.toLowerCase());

      final description = isMasyarakat
          ? 'Sampaikan pengaduan dan pantau perkembangan '
                'laporan Anda melalui SIGAP KAWAN.'
          : 'Kelola layanan dan pantau pengaduan masyarakat '
                'melalui satu dashboard.';

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
          clipBehavior: Clip.none,
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
                            'SIGAP KAWAN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
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
                Text(
                  'Selamat datang, ${profile.name}! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                if (role?.unitNama.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_city_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          role!.unitNama,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLoading() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.blueDark, AppColors.blue],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildError(SharedProfileController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          const Icon(Icons.person_off_rounded, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          const Text(
            'Profil belum tersedia',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: controller.fetchProfile,
            child: const Text(
              'Coba lagi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
