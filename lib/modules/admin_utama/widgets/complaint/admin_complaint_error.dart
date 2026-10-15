import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminComplaintError extends StatelessWidget {
  const AdminComplaintError({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(
          Icons.cloud_off_outlined,
          size: 54,
          color: AppColors.iconSecondary,
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Gagal mengambil pengaduan',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Coba lagi'),
          ),
        ),
      ],
    );
  }
}
