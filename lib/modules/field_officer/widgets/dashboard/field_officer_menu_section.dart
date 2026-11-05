import 'package:sapahub/app/routes/app_routes.dart';
import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/shared/widgets/dashboard/dashboard_menu_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldOfficerMenuSection extends StatelessWidget {
  const FieldOfficerMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardMenuSection(
      title: 'Menu Utama',
      subtitle: 'Akses layanan penanganan pengaduan lapangan.',
      // crossAxisCount: 2,
      // childAspectRatio: 2.05,
      trailingLabel: 'Semua fitur',
      crossAxisCount: 3,
      childAspectRatio: 1.15,
      compact: true,
      items: [
        DashboardMenuEntry(
          icon: Icons.assignment_outlined,
          title: 'Pengaduan Saya',
          subtitle: 'Tugas penanganan pengaduan',
          color: AppColors.blue,
          onTap: () => Get.toNamed(AppRoutes.fieldOfficerComplaints),
        ),
        DashboardMenuEntry(
          icon: Icons.person_outline_rounded,
          title: 'Profil Saya',
          subtitle: 'Informasi akun',
          color: AppColors.navy,
          onTap: () => Get.toNamed(AppRoutes.fieldOfficerProfile),
        ),
      ],
    );
  }
}
