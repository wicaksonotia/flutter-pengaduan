import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'eLingk',
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        Gap(4),
        Text(
          'Layanan Pengaduan Masyarakat',
          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }
}
