import 'package:sapahub/app/routes/app_routes.dart';
import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/shared/widgets/dashboard/dashboard_menu_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUtamaMenuSection extends StatelessWidget {
  const AdminUtamaMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardMenuSection(
      title: 'Menu Utama',
      subtitle: 'Pilih layanan yang ingin kamu kelola.',
      trailingLabel: 'Semua fitur',
      crossAxisCount: 3,
      childAspectRatio: 1.15,
      compact: true,
      items: [
        DashboardMenuEntry(
          icon: Icons.assignment_rounded,
          title: 'Pengaduan',
          subtitle: 'Laporan masuk',
          color: AppColors.blue,
          onTap: () => Get.toNamed(AppRoutes.adminUtamaComplaints),
        ),
        DashboardMenuEntry.comingSoon(
          icon: Icons.apartment_rounded,
          title: 'Instansi & Unit',
          subtitle: 'Data unit',
          color: AppColors.teal,
          messageTitle: 'Instansi dan Unit',
        ),
        DashboardMenuEntry.comingSoon(
          icon: Icons.people_alt_rounded,
          title: 'Pengguna',
          subtitle: 'Hak akses',
          color: AppColors.purple,
          messageTitle: 'Pengguna dan Hak Akses',
        ),
        DashboardMenuEntry(
          icon: Icons.newspaper_rounded,
          title: 'Berita',
          subtitle: 'Informasi',
          color: AppColors.pink,
          onTap: () => Get.toNamed(AppRoutes.adminUtamaBerita),
        ),
        DashboardMenuEntry(
          icon: Icons.person_rounded,
          title: 'Profil Admin',
          subtitle: 'Akun saya',
          color: AppColors.indigo,
          onTap: () => Get.toNamed(AppRoutes.adminUtamaProfile),
        ),
      ],
    );
  }
}
