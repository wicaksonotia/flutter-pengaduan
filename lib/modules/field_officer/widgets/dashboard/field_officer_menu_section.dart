import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/field_officer/views/complaints/field_officer_complaints_view.dart';
import 'package:elingk/modules/shared/views/shared_profile_view.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldOfficerMenuSection extends StatelessWidget {
  const FieldOfficerMenuSection({super.key});

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
          title: 'Pengaduan Saya',
          subtitle: 'Lihat dan tindak lanjuti tugas pengaduan',
          onTap: () => Get.to(() => const FieldOfficerComplaintsView()),
        ),

        AdminMenuTile(
          icon: Icons.person_outline_rounded,
          title: 'Profil Saya',
          subtitle: 'Informasi akun dan pengaturan akun',
          onTap: () => Get.to(
            () => const SharedProfileView(
              roleName: 'Petugas Lapangan',
              description: 'Pelaksana tindak lanjut pengaduan eLingk',
            ),
          ),
        ),
      ],
    );
  }
}
