import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HelpCard extends StatelessWidget {
  const HelpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, size: 30, color: Color(0xFF168C7D)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layanan yang transparan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pantau perkembangan laporanmu melalui aplikasi.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
