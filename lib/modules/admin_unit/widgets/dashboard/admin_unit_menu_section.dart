import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elingk/modules/admin_unit/views/complaints/admin_unit_complaints_view.dart';

class AdminUnitMenuSection extends StatelessWidget {
  const AdminUnitMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Utama',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        AdminMenuTile(
          icon: Icons.assignment_outlined,
          title: 'Pengaduan Unit',
          subtitle: 'Lihat dan kelola pengaduan yang masuk',
          onTap: _openComplaints,
        ),
        const SizedBox(height: 12),
        AdminMenuTile(
          icon: Icons.groups_outlined,
          title: 'Petugas Lapangan',
          subtitle: 'Kelola penugasan petugas lapangan',
          onTap: () => _showComingSoon('Petugas Lapangan'),
        ),
      ],
    );
  }

  void _openComplaints() {
    Get.to(() => const AdminUnitComplaintsView());
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      feature,
      'Halaman ini akan dibuat pada tahap berikutnya.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
