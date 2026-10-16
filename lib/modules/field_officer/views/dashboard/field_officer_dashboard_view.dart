import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/field_officer/widgets/dashboard/field_officer_menu_section.dart';
import 'package:elingk/modules/field_officer/widgets/dashboard/field_officer_recent_complaints.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_header.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_welcome_card.dart';
import 'package:flutter/material.dart';

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
            const SizedBox(height: 26),
            const AdminWelcomeCard(),
            const SizedBox(height: 28),
            const FieldOfficerMenuSection(),
            const SizedBox(height: 28),
            const FieldOfficerRecentComplaints(),
            const SizedBox(height: 20),
            const _DashboardFooter(),
          ],
        ),
      ),
    );
  }
}

class _DashboardFooter extends StatelessWidget {
  const _DashboardFooter();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'eLingk • Layanan Pengaduan Masyarakat',
      textAlign: TextAlign.center,
      style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
    );
  }
}
