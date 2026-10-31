import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeWelcome extends StatelessWidget {
  const HomeWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, Sahabat Lingkungan 👋',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Ada yang ingin kamu\nsampaikan hari ini?',
          style: TextStyle(
            fontSize: 27,
            height: 1.25,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
