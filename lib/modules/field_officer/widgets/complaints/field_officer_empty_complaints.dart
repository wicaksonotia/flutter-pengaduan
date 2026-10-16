import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FieldOfficerEmptyComplaints extends StatelessWidget {
  const FieldOfficerEmptyComplaints({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: const [
        SizedBox(height: 100),
        Icon(
          Icons.assignment_outlined,
          size: 60,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 16),
        Text(
          'Belum ada pengaduan',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Tugas yang diberikan kepada Anda akan tampil di sini.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
      ],
    );
  }
}
