import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_unit/controllers/admin_unit_dashboard_controller.dart';
import 'package:sigapkawan/modules/admin_unit/widgets/dashboard/admin_unit_menu_section.dart';
import 'package:sigapkawan/modules/admin_unit/widgets/dashboard/admin_unit_recent_complaints.dart';
import 'package:sigapkawan/modules/admin_unit/widgets/dashboard/admin_unit_stats_section.dart';
import 'package:sigapkawan/modules/shared/widgets/dashboard/dashboard_header.dart';
import 'package:sigapkawan/modules/shared/widgets/dashboard/dashboard_footer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AdminUnitDashboardView extends GetView<AdminUnitDashboardController> {
  const AdminUnitDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              const DashboardHeader(),
              const Gap(26),
              const AdminUnitStatsSection(),
              const Gap(28),
              const AdminUnitMenuSection(),
              const Gap(28),
              const AdminUnitRecentComplaints(),
              const Gap(20),
              const DashboardFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
