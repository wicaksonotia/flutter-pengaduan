import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_unit/bindings/admin_unit_binding.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaints_controller.dart';
import 'package:elingk/modules/admin_unit/widgets/dashboard/admin_unit_menu_section.dart';
import 'package:elingk/modules/admin_unit/widgets/dashboard/admin_unit_recent_complaints.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_header.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitDashboardView extends StatefulWidget {
  const AdminUnitDashboardView({super.key});

  @override
  State<AdminUnitDashboardView> createState() => _AdminUnitDashboardViewState();
}

class _AdminUnitDashboardViewState extends State<AdminUnitDashboardView> {
  late final AdminUnitComplaintsController controller;

  @override
  void initState() {
    super.initState();

    AdminUnitBinding().dependencies();
    controller = Get.find<AdminUnitComplaintsController>();
  }

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
            children: [
              const AdminHeader(roleCode: 'unit_admin'),
              const SizedBox(height: 26),
              const AdminWelcomeCard(),
              const SizedBox(height: 28),
              const AdminUnitMenuSection(),
              const SizedBox(height: 28),
              const AdminUnitRecentComplaints(),
              const SizedBox(height: 20),
              const _DashboardFooter(),
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
