import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/widgets/dashboard/dashboard_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DashboardMenuEntry {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const DashboardMenuEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  factory DashboardMenuEntry.comingSoon({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String messageTitle,
  }) {
    return DashboardMenuEntry(
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: color,
      onTap: () => showDashboardComingSoon(messageTitle),
    );
  }
}

class DashboardMenuSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<DashboardMenuEntry> items;
  final int crossAxisCount;
  final double childAspectRatio;
  final bool compact;
  final String? trailingLabel;

  const DashboardMenuSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.crossAxisCount = 2,
    this.childAspectRatio = 2.05,
    this.compact = false,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailingLabel != null)
              Text(
                trailingLabel!,
                style: const TextStyle(
                  color: AppColors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const Gap(4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const Gap(15),
        GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: childAspectRatio,
          children: items.map((item) {
            return DashboardMenuItem(
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              color: item.color,
              compact: compact,
              onTap: item.onTap,
            );
          }).toList(),
        ),
      ],
    );
  }
}

void showDashboardComingSoon(String title) {
  Get.snackbar(
    title,
    'Modul ini akan kita bangun pada tahap berikutnya.',
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    backgroundColor: AppColors.navy,
    colorText: AppColors.white,
  );
}
