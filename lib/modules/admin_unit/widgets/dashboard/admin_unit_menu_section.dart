import 'package:elingk/app/routes/app_routes.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/widgets/dashboard/dashboard_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitMenuSection extends StatelessWidget {
  const AdminUnitMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Utama',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Akses layanan pengelolaan unit kerja.',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 15),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.05,
          children: [
            DashboardMenuItem(
              icon: Icons.assignment_outlined,
              title: 'Pengaduan',
              subtitle: 'Kelola laporan masuk',
              color: AppColors.blue,
              onTap: () {
                Get.toNamed(AppRoutes.adminUnitComplaints);
              },
            ),
            DashboardMenuItem(
              icon: Icons.article_outlined,
              title: 'Berita',
              subtitle: 'Informasi dan pengumuman',
              color: AppColors.teal,
              onTap: () {
                Get.toNamed(AppRoutes.adminUnitBerita);
              },
            ),
            DashboardMenuItem(
              icon: Icons.people_alt_outlined,
              title: 'Petugas',
              subtitle: 'Petugas lapangan',
              color: AppColors.warning,
              onTap: () {
                Get.snackbar(
                  'Petugas Lapangan',
                  'Modul ini akan kita bangun pada tahap berikutnya.',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                );
              },
            ),
            DashboardMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'Profil Admin',
              subtitle: 'Informasi akun',
              color: AppColors.navy,
              onTap: () => Get.toNamed(AppRoutes.adminUnitProfile),
            ),
          ],
        ),
      ],
    );
  }
}
