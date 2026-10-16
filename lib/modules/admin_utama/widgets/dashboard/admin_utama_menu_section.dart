import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/views/categories/admin_complaint_categories_view.dart';
import 'package:elingk/modules/admin_utama/views/complaints/admin_complaints_view.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_menu_tile.dart';
import 'package:elingk/modules/shared/views/admin_profile_view.dart';
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
          subtitle: 'Periksa, kategorikan, dan delegasikan aduan',
          onTap: () => Get.to(() => const AdminComplaintsView()),
        ),
        AdminMenuTile(
          icon: Icons.apartment_rounded,
          title: 'Instansi dan Unit',
          subtitle: 'Kelola organisasi dan unit kerja',
          onTap: () => _showComingSoon('Instansi dan Unit'),
        ),
        AdminMenuTile(
          icon: Icons.people_alt_outlined,
          title: 'Pengguna dan Hak Akses',
          subtitle: 'Kelola admin unit dan petugas lapangan',
          onTap: () => _showComingSoon('Pengguna'),
        ),
        AdminMenuTile(
          icon: Icons.category_outlined,
          title: 'Kategori Pengaduan',
          subtitle: 'Kelola kategori dan klasifikasi pengaduan',
          onTap: () => Get.to(() => AdminComplaintCategoriesView()),
        ),
        AdminMenuTile(
          icon: Icons.person_outline_rounded,
          title: 'Profil Admin',
          subtitle: 'Informasi dan pengaturan akun',
          onTap: () => Get.to(
            () => const AdminProfileView(
              roleName: 'Admin Utama',
              description: 'Pengelola layanan eLingk',
            ),
          ),
        ),
      ],
    );
  }
}
