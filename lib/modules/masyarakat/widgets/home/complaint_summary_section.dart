import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'section_header.dart';

class ComplaintSummarySection extends StatelessWidget {
  const ComplaintSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Ringkasan Pengaduan',
          actionLabel: 'Lihat semua',
          onAction: () {
            // TODO: Navigasi ke tab pengaduan.
          },
        ),
        const SizedBox(height: 14),
        const Row(
          children: [
            Expanded(
              child: _StatisticCard(
                icon: Icons.assignment_outlined,
                label: 'Total',
                value: '0',
                color: AppColors.blue,
                background: Color(0xFFEAF2FF),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _StatisticCard(
                icon: Icons.hourglass_top_rounded,
                label: 'Diproses',
                value: '0',
                color: Color(0xFFDD8A13),
                background: Color(0xFFFFF4DF),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _StatisticCard(
                icon: Icons.check_circle_outline_rounded,
                label: 'Selesai',
                value: '0',
                color: Color(0xFF119B79),
                background: Color(0xFFE3F8F1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBEFF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 13),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
