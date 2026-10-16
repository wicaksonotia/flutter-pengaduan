import 'package:elingk/modules/admin_unit/widgets/dashboard/admin_unit_info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaints_controller.dart';
import 'package:elingk/modules/admin_unit/views/complaints/admin_unit_complaints_view.dart';

class AdminUnitRecentComplaints extends GetView<AdminUnitComplaintsController> {
  const AdminUnitRecentComplaints({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Pengaduan Terbaru',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: _openComplaints,
              child: Text(
                'Lihat semua',
                style: TextStyle(color: AppColors.navy),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isLoading.value && controller.complaints.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(28),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.complaints.isEmpty) {
            return AdminUnitInfoCard(
              icon: Icons.cloud_off_outlined,
              message: controller.errorMessage.value,
              onRetry: controller.refreshComplaints,
            );
          }

          if (controller.complaints.isEmpty) {
            return const AdminUnitInfoCard(
              icon: Icons.inbox_outlined,
              message: 'Belum ada pengaduan untuk ditampilkan.',
            );
          }

          final items = controller.complaints.take(3).toList();

          return Column(
            children: items.map((complaint) {
              final nomor =
                  complaint['nomor_pengaduan']?.toString() ?? 'Pengaduan';
              final judul = complaint['judul']?.toString() ?? 'Tanpa judul';
              final status = complaint['status']?.toString() ?? 'diajukan';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.navy.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: AppColors.navy,
                    ),
                  ),
                  title: Text(
                    judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '$nomor\n${status.replaceAll('_', ' ')}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                  isThreeLine: true,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                  onTap: _openComplaints,
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  void _openComplaints() {
    Get.to(() => const AdminUnitComplaintsView());
  }
}
