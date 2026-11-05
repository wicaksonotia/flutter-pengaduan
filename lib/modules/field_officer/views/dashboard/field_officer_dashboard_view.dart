import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/field_officer/controllers/field_officer_dashboard_controller.dart';
import 'package:sapahub/modules/field_officer/widgets/dashboard/field_officer_menu_section.dart';
import 'package:sapahub/modules/field_officer/widgets/dashboard/field_officer_recent_complaints.dart';
import 'package:sapahub/modules/field_officer/widgets/dashboard/field_officer_stats_section.dart';
import 'package:sapahub/modules/shared/widgets/dashboard/dashboard_header.dart';
import 'package:sapahub/modules/shared/widgets/dashboard/dashboard_footer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FieldOfficerDashboardView
    extends GetView<FieldOfficerDashboardController> {
  const FieldOfficerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(20),
            children: [
              const DashboardHeader(),
              const Gap(26),
              const FieldOfficerStatsSection(),
              const Gap(28),
              const FieldOfficerMenuSection(),
              const Gap(28),
              const FieldOfficerRecentComplaints(),
              const Gap(20),
              const DashboardFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
