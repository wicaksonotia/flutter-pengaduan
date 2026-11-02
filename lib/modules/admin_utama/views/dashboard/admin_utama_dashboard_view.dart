import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_utama_dashboard_controller.dart';
import 'package:elingk/modules/admin_utama/widgets/dashboard/admin_utama_menu_section.dart';
import 'package:elingk/modules/admin_utama/widgets/dashboard/admin_utama_stats_section.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUtamaDashboardView extends GetView<AdminUtamaDashboardController> {
  const AdminUtamaDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          color: AppColors.blue,
          backgroundColor: AppColors.surface,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              const AdminHeader(roleCode: 'main_admin'),
              const SizedBox(height: 26),

              AdminUtamaStatsSection(controller: controller),

              const SizedBox(height: 28),

              const AdminUtamaMenuSection(),

              const SizedBox(height: 24),

              const Text(
                'eLingk • Layanan Pengaduan Masyarakat',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
