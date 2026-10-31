import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'section_header.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Aktivitas Terbaru',
          actionLabel: 'Lihat riwayat',
          onAction: () {
            // TODO: Navigasi ke riwayat pengaduan.
          },
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEBEFF5)),
          ),
          child: const Column(
            children: [
              Icon(Icons.inbox_rounded, size: 42, color: Color(0xFFB7C4D7)),
              SizedBox(height: 10),
              Text(
                'Belum ada pengaduan',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Pengaduan yang kamu kirim akan muncul di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
