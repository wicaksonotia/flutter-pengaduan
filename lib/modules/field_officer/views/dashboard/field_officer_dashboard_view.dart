import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/field_officer/widgets/dashboard/field_officer_menu_section.dart';
import 'package:elingk/modules/field_officer/widgets/dashboard/field_officer_recent_complaints.dart';
import 'package:elingk/modules/field_officer/widgets/dashboard/field_officer_stats_section.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_header.dart';
import 'package:elingk/modules/shared/widgets/dashboard/dashboard_footer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FieldOfficerDashboardView extends StatelessWidget {
  const FieldOfficerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            const AdminHeader(roleCode: 'field_officer'),
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
    );
  }
}
