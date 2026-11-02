import 'package:elingk/app/routes/app_routes.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/views/shared_profile_view.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitMenuSection extends StatelessWidget {
  const AdminUnitMenuSection({super.key});

  void _showComingSoon(String title) {
    Get.snackbar(
      title,
      'Modul ini akan kita bangun pada tahap berikutnya.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Utama',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),

        AdminMenuTile(
          icon: Icons.assignment_outlined,
          title: 'Pengelolaan Pengaduan',
          subtitle: 'Periksa dan tindak lanjuti pengaduan unit',
          onTap: () => _showComingSoon('Pengelolaan Pengaduan'),
        ),

        AdminMenuTile(
          icon: Icons.article_outlined,
          title: 'Berita & Pengumuman',
          subtitle: 'Kelola informasi dan publikasi instansi',
          onTap: () => Get.toNamed(AppRoutes.adminUnitBerita),
        ),

        AdminMenuTile(
          icon: Icons.people_alt_outlined,
          title: 'Petugas Lapangan',
          subtitle: 'Informasi dan pengelolaan petugas unit',
          onTap: () => _showComingSoon('Petugas Lapangan'),
        ),

        AdminMenuTile(
          icon: Icons.person_outline_rounded,
          title: 'Profil Admin',
          subtitle: 'Informasi dan pengaturan akun',
          onTap: () => Get.to(
            () => const SharedProfileView(
              roleName: 'Admin Unit',
              description: 'Pengelola layanan unit kerja',
            ),
          ),
        ),
      ],
    );
  }
}
