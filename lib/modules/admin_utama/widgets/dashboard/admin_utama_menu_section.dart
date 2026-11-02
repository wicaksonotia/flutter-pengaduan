import 'package:elingk/app/routes/app_routes.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/views/complaints/admin_complaints_view.dart';
import 'package:elingk/modules/shared/views/shared_profile_view.dart';
import 'package:elingk/modules/shared/widgets/dashboard/dashboard_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUtamaMenuSection extends StatelessWidget {
  const AdminUtamaMenuSection({super.key});

  void _showComingSoon(String title) {
    Get.snackbar(
      title,
      'Modul ini akan kita bangun pada tahap berikutnya.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: AppColors.navy,
      colorText: AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                'Akses Menu',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              'Semua fitur',
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Pilih layanan yang ingin kamu kelola.',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 15),

        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.15,
          children: [
            DashboardMenuItem(
              icon: Icons.assignment_rounded,
              title: 'Pengaduan',
              subtitle: 'Laporan masuk',
              color: AppColors.blue,
              compact: true,
              onTap: () => Get.toNamed(AppRoutes.adminUtamaComplaints),
            ),
            DashboardMenuItem(
              icon: Icons.apartment_rounded,
              title: 'Instansi & Unit',
              subtitle: 'Data unit',
              color: AppColors.teal,
              compact: true,
              onTap: () => _showComingSoon('Instansi dan Unit'),
            ),
            DashboardMenuItem(
              icon: Icons.people_alt_rounded,
              title: 'Pengguna',
              subtitle: 'Hak akses',
              color: AppColors.purple,
              compact: true,
              onTap: () => _showComingSoon('Pengguna dan Hak Akses'),
            ),
            DashboardMenuItem(
              icon: Icons.newspaper_rounded,
              title: 'Berita',
              subtitle: 'Informasi',
              color: AppColors.pink,
              compact: true,
              onTap: () => Get.toNamed(AppRoutes.adminUtamaBerita),
            ),
            DashboardMenuItem(
              icon: Icons.person_rounded,
              title: 'Profil Admin',
              subtitle: 'Akun saya',
              color: AppColors.indigo,
              compact: true,
              onTap: () => Get.to(
                () => const SharedProfileView(
                  roleName: 'Admin Utama',
                  description: 'Pengelola layanan eLingk',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
