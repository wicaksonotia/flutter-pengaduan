import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminUnitComplaintDetailActions extends StatelessWidget {
  const AdminUnitComplaintDetailActions({
    super.key,
    required this.isLoading,
    required this.loadingOfficers,
    required this.isAssigning,
    required this.onAssignOfficer,
  });

  final bool isLoading;
  final bool loadingOfficers;
  final bool isAssigning;
  final VoidCallback onAssignOfficer;

  @override
  Widget build(BuildContext context) {
    final label = loadingOfficers
        ? 'Memuat daftar petugas...'
        : isAssigning
        ? 'Meneruskan pengaduan...'
        : 'Teruskan ke Field Officer';

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onAssignOfficer,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.textOnPrimary,
                ),
              )
            : const Icon(Icons.assignment_ind_outlined),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.75),
          disabledForegroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
