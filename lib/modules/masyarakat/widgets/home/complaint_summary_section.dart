import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/masyarakat/controllers/masyarakat_dashboard_controller.dart';
import 'package:sigapkawan/modules/shared/widgets/dashboard/dashboard_stats_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintSummarySection extends StatelessWidget {
  const ComplaintSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MasyarakatDashboardController>();

    return Obx(
      () => DashboardStatsPanel(
        total: controller.totalPengaduan,
        isLoading: controller.isLoading.value,
        errorMessage: controller.errorMessage.value,
        onRetry: controller.refreshDashboard,
        totalSubtitle: 'Pengaduan yang telah Anda sampaikan',
        chartTitle: 'Distribusi Status Pengaduan',
        items: [
          DashboardStatItem(
            title: 'Menunggu Tindak Lanjut',
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
