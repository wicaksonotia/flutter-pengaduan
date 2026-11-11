import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_unit/controllers/admin_unit_dashboard_controller.dart';
import 'package:sigapkawan/modules/shared/widgets/dashboard/dashboard_stats_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitStatsSection extends GetView<AdminUnitDashboardController> {
  const AdminUnitStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DashboardStatsPanel(
        total: controller.totalPengaduan,
        isLoading: controller.isLoading.value,
        errorMessage: controller.errorMessage.value,
        onRetry: controller.refreshDashboard,
        totalSubtitle: 'Seluruh laporan unit kerja',
        items: [
          DashboardStatItem(
            title: 'Pengaduan Masuk',
            value: controller.pengaduanMasuk,
            color: AppColors.blue,
          ),
          DashboardStatItem(
            title: 'Dalam Penanganan',
            value: controller.dalamPenanganan,
            color: AppColors.warning,
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
