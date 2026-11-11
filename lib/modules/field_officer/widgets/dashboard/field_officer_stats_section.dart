import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/field_officer/controllers/field_officer_dashboard_controller.dart';
import 'package:sigapkawan/modules/shared/widgets/dashboard/dashboard_stats_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldOfficerStatsSection
    extends GetView<FieldOfficerDashboardController> {
  const FieldOfficerStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DashboardStatsPanel(
        total: controller.totalTugas,
        isLoading: controller.isLoading.value,
        errorMessage: controller.errorMessage.value,
        onRetry: controller.refreshDashboard,
        totalSubtitle: 'Seluruh tugas pengaduan yang diberikan kepada Anda',
        items: [
          DashboardStatItem(
            title: 'Dalam Penanganan',
            value: controller.tugasDiproses,
            color: AppColors.warning,
          ),
          DashboardStatItem(
            title: 'Menunggu Pemeriksaan',
            value: controller.menungguPemeriksaanUnit,
            color: AppColors.teal,
          ),
        ],
      ),
    );
  }
}
