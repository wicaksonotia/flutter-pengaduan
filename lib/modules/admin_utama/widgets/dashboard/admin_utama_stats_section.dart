import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_utama_dashboard_controller.dart';
import 'package:elingk/modules/shared/widgets/dashboard/dashboard_stats_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUtamaStatsSection extends StatelessWidget {
  final AdminUtamaDashboardController controller;

  const AdminUtamaStatsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DashboardStatsPanel(
        total: controller.totalPengaduan,
        isLoading: controller.isLoading.value,
        errorMessage: controller.errorMessage.value,
        onRetry: controller.refreshDashboard,
        totalSubtitle: 'Seluruh laporan masyarakat',
        items: [
          DashboardStatItem(
            title: 'Pengaduan Baru',
            value: controller.pengaduanBaru,
            color: AppColors.orange,
          ),
          DashboardStatItem(
            title: 'Ditugaskan',
            value: controller.pengaduanDitugaskan,
            color: AppColors.blue,
          ),
          DashboardStatItem(
            title: 'Dalam Penanganan',
            value: controller.dalamPenanganan,
            color: AppColors.purple,
          ),
          DashboardStatItem(
            title: 'Menunggu Verifikasi',
            value: controller.menungguVerifikasi,
            color: AppColors.teal,
          ),
          DashboardStatItem(
            title: 'Pengaduan Selesai',
            value: controller.pengaduanSelesai,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}
