import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/masyarakat/widgets/home/complaint_summary_section.dart';
import 'package:sigapkawan/modules/masyarakat/widgets/home/help_card.dart';
import 'package:sigapkawan/modules/masyarakat/widgets/home/news_section.dart';
import 'package:sigapkawan/modules/shared/widgets/dashboard/dashboard_header.dart';
import 'package:sigapkawan/modules/shared/widgets/dashboard/dashboard_footer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
            const DashboardHeader(),
            const Gap(26),
            const ComplaintSummarySection(),
            const Gap(28),
            // const ActivitySection(),
            // const SizedBox(height: 28),
            const NewsSection(),
            const Gap(24),
            const HelpCard(),
            const Gap(24),
            DashboardFooter(),
          ],
        ),
      ),
    );
  }
}
