import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/widgets/home/activity_section.dart';
import 'package:elingk/modules/masyarakat/widgets/home/complaint_summary_section.dart';
import 'package:elingk/modules/masyarakat/widgets/home/help_card.dart';
import 'package:elingk/modules/masyarakat/widgets/home/news_section.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_header.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            const AdminHeader(roleCode: 'masyarakat'),
            const SizedBox(height: 26),

            const ComplaintSummarySection(),
            const SizedBox(height: 28),

            // const ActivitySection(),
            // const SizedBox(height: 28),
            const NewsSection(),
            const SizedBox(height: 24),

            const HelpCard(),

            const SizedBox(height: 24),

            const Text(
              'eLingk • Layanan Pengaduan Masyarakat',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
