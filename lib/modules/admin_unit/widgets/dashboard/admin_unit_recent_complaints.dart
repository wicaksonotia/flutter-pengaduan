import 'package:sigapkawan/app/routes/app_routes.dart';
import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_unit/controllers/admin_unit_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitRecentComplaints extends GetView<AdminUnitDashboardController> {
  const AdminUnitRecentComplaints({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Pengaduan Terbaru',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.adminUnitComplaints);
              },
              child: const Text('Lihat semua'),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Obx(() {
          if (controller.isLoading.value &&
              controller.recentComplaints.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.recentComplaints.isEmpty) {
            return _InfoCard(
              icon: Icons.error_outline,
              message: controller.errorMessage.value,
              actionLabel: 'Coba Lagi',
              onAction: controller.fetchDashboard,
            );
          }

          if (controller.recentComplaints.isEmpty) {
            return const _InfoCard(
              icon: Icons.inbox_outlined,
              message: 'Belum ada pengaduan yang masuk.',
            );
          }

          return Column(
            children: controller.recentComplaints.map((complaint) {
              return _ComplaintItem(complaint: complaint);
            }).toList(),
          );
        }),
      ],
    );
  }
}

class _ComplaintItem extends StatelessWidget {
  final Map<String, dynamic> complaint;

  const _ComplaintItem({required this.complaint});

  @override
  Widget build(BuildContext context) {
    final nomor = complaint['nomor_pengaduan']?.toString() ?? '-';
    final judul = complaint['judul']?.toString() ?? 'Tanpa judul';
    final status = complaint['status']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: AppColors.blue,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomor,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _StatusLabel(status: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final String status;

  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();

    final Color color;
    if (normalized.contains('selesai')) {
      color = AppColors.success;
    } else if (normalized.contains('tolak') || normalized.contains('batal')) {
      color = AppColors.danger;
    } else if (normalized.contains('proses')) {
      color = AppColors.warning;
    } else {
      color = AppColors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _InfoCard({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: AppColors.iconSecondary),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 10),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
