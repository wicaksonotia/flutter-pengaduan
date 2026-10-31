import 'package:elingk/modules/masyarakat/widgets/home/activity_section.dart';
import 'package:elingk/modules/masyarakat/widgets/home/complaint_hero_card.dart';
import 'package:elingk/modules/masyarakat/widgets/home/complaint_summary_section.dart';
import 'package:elingk/modules/masyarakat/widgets/home/help_card.dart';
import 'package:elingk/modules/masyarakat/widgets/home/home_header.dart';
import 'package:elingk/modules/masyarakat/widgets/home/home_welcome.dart';
import 'package:elingk/modules/masyarakat/widgets/home/news_section.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const HomeHeader(),
                const SizedBox(height: 28),
                const HomeWelcome(),
                const SizedBox(height: 24),
                const ComplaintHeroCard(),
                const SizedBox(height: 28),
                const ComplaintSummarySection(),
                const SizedBox(height: 28),
                const NewsSection(),
                const SizedBox(height: 28),
                const ActivitySection(),
                const SizedBox(height: 24),
                const HelpCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
