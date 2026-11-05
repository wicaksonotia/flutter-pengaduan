import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/admin_utama/controllers/admin_utama_dashboard_controller.dart';
import 'package:sapahub/modules/admin_utama/widgets/dashboard/admin_utama_menu_section.dart';
import 'package:sapahub/modules/admin_utama/widgets/dashboard/admin_utama_stats_section.dart';
import 'package:sapahub/modules/shared/widgets/dashboard/dashboard_header.dart';
import 'package:sapahub/modules/shared/widgets/dashboard/dashboard_footer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
              const DashboardHeader(),
              const Gap(26),
              AdminUtamaStatsSection(controller: controller),
              const Gap(28),
              const AdminUtamaMenuSection(),
              const Gap(20),
              const DashboardFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
