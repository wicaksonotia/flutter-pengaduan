import 'package:elingk/modules/admin_unit/widgets/dashboard/admin_unit_menu_section.dart';
import 'package:elingk/modules/admin_unit/widgets/dashboard/admin_unit_recent_complaints.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_header.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaints_controller.dart';

class AdminUnitDashboardView extends GetView<AdminUnitComplaintsController> {
  const AdminUnitDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshComplaints,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: const [
              AdminHeader(),
              SizedBox(height: 26),
              AdminWelcomeCard(),
              SizedBox(height: 28),
              AdminUnitMenuSection(),
              SizedBox(height: 28),
              AdminUnitRecentComplaints(),
              SizedBox(height: 20),
              _DashboardFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardFooter extends StatelessWidget {
  const _DashboardFooter();

  @override
  Widget build(BuildContext context) {
    return Text(
      'eLingk • Layanan Pengaduan Masyarakat',
      textAlign: TextAlign.center,
      style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
    );
  }
}
