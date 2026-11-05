import 'package:sapahub/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'SAPA HUB',
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: 1,
          ),
        ),
        Gap(4),
        Text(
          'Saluran Aspirasi dan Pengaduan Perhubungan',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
        Gap(3),
        Text(
          'Suara Anda, Kepedulian Kami.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
