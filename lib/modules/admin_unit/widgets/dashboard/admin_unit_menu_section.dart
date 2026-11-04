import 'package:elingk/app/routes/app_routes.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/widgets/dashboard/dashboard_menu_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitMenuSection extends StatelessWidget {
  const AdminUnitMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardMenuSection(
      title: 'Menu Utama',
      subtitle: 'Akses layanan pengelolaan unit kerja.',
      // crossAxisCount: 2,
      // childAspectRatio: 2.05,
      trailingLabel: 'Semua fitur',
      crossAxisCount: 3,
      childAspectRatio: 1.15,
      compact: true,
      items: [
        DashboardMenuEntry(
          icon: Icons.assignment_outlined,
          title: 'Pengaduan',
          subtitle: 'Kelola laporan masuk',
          color: AppColors.blue,
          onTap: () => Get.toNamed(AppRoutes.adminUnitComplaints),
        ),
        DashboardMenuEntry(
          icon: Icons.article_outlined,
          title: 'Berita',
          subtitle: 'Informasi dan pengumuman',
          color: AppColors.teal,
          onTap: () => Get.toNamed(AppRoutes.adminUnitBerita),
        ),
        DashboardMenuEntry.comingSoon(
          icon: Icons.people_alt_outlined,
          title: 'Petugas',
          subtitle: 'Petugas lapangan',
          color: AppColors.warning,
          messageTitle: 'Petugas Lapangan',
        ),
        DashboardMenuEntry(
          icon: Icons.person_outline_rounded,
          title: 'Profil Admin',
          subtitle: 'Informasi akun',
          color: AppColors.navy,
          onTap: () => Get.toNamed(AppRoutes.adminUnitProfile),
        ),
      ],
    );
  }
}
