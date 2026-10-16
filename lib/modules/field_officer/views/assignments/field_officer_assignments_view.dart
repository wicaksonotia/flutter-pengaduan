import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/widgets/app_empty_state.dart';
import 'package:elingk/app/widgets/app_header.dart';
import 'package:elingk/modules/field_officer/controllers/field_officer_assignments_controller.dart';
import 'package:elingk/modules/shared/constants/complaint_status.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_error.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldOfficerAssignmentsView
    extends GetView<FieldOfficerAssignmentsController> {
  const FieldOfficerAssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tugas Lapangan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.assignments.isEmpty) {
          return const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: SharedComplaintLoading(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.assignments.isEmpty) {
          return SharedComplaintError(
            message: controller.errorMessage.value,
            onRetry: controller.refreshAssignments,
          );
        }

        return RefreshIndicator(
          color: AppColors.blue,
          onRefresh: controller.refreshAssignments,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Obx(
                () => Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.textOnPrimary.withValues(
                            alpha: 0.16,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.assignment_outlined,
                          color: AppColors.textOnPrimary,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Tugas',
                              style: TextStyle(
                                color: AppColors.textOnPrimary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${controller.total.value}',
                              style: const TextStyle(
                                color: AppColors.textOnPrimary,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              AppHeader(
                title: 'Daftar Tugas',
                subtitle: 'Pengaduan yang ditugaskan kepada Anda',
                badgeText: '${controller.assignments.length} tugas',
                badgeColor: AppColors.blue,
                badgeIcon: Icons.assignment_ind_outlined,
              ),
              const SizedBox(height: 12),

              if (controller.assignments.isEmpty)
                const AppEmptyState(
                  title: 'Belum ada tugas',
                  description:
                      'Tugas yang diberikan Admin Unit akan muncul di sini.',
                  icon: Icons.assignment_outlined,
                )
              else
                ...controller.assignments.map((assignment) {
                  final complaint = _asMap(assignment['complaint']);

                  final id = assignment['id'];
                  final nomor =
                      complaint['nomor_pengaduan'] ??
                      'Pengaduan #${complaint['id'] ?? '-'}';
                  final judul = complaint['judul'] ?? 'Pengaduan tanpa judul';
                  final status = '${complaint['status'] ?? ''}';
                  final catatan = assignment['catatan'];
                  final unit = _asMap(complaint['unit']);
                  final assignedAt = assignment['ditugaskan_pada'];

                  return Padding(
                    key: ValueKey(id),
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withValues(alpha: 0.09),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.assignment_outlined,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nomor.toString(),
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      judul.toString(),
                                      style: const TextStyle(
                                        color: AppColors.navy,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          if (unit['nama'] != null) ...[
                            _infoRow(
                              Icons.business_outlined,
                              unit['nama'].toString(),
                            ),
                            const SizedBox(height: 8),
                          ],

                          if (assignedAt != null) ...[
                            _infoRow(
                              Icons.schedule_outlined,
                              _formatDate(assignedAt.toString()),
                            ),
                            const SizedBox(height: 8),
                          ],

                          if (catatan != null &&
                              catatan.toString().trim().isNotEmpty) ...[
                            _infoRow(Icons.notes_outlined, catatan.toString()),
                            const SizedBox(height: 12),
                          ],

                          Row(
                            children: [
                              Expanded(child: _statusChip(status)),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.info_outline,
                                size: 17,
                                color: AppColors.blue,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Detail berikutnya',
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              if (controller.isLoadingMore.value)
                const SharedComplaintLoading(itemCount: 1, showSummary: false),

              if (!controller.isLoadingMore.value && controller.hasMore)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  child: OutlinedButton(
                    onPressed: controller.loadMore,
                    child: const Text('Muat lebih banyak'),
                  ),
                ),

              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    final label =
        ComplaintStatus.statusLabels[status] ??
        (status.isEmpty ? 'Status belum tersedia' : status);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.blue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.blue,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value)?.toLocal();

    if (date == null) return value;

    String twoDigits(int number) => number.toString().padLeft(2, '0');

    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}'
        ' ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}
