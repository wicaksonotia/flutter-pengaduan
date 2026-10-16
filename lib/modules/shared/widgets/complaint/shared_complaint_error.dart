import 'package:flutter/material.dart';
import 'package:elingk/app/theme/app_colors.dart';

class SharedComplaintError extends StatelessWidget {
  const SharedComplaintError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 32),
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
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
