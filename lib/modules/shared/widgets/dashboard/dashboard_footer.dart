import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'SigapKawan • Suara Warga, Aksi Nyata',
      textAlign: TextAlign.center,
      style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
    );
  }
}
