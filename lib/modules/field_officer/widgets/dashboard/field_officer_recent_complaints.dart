import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/field_officer/bindings/field_officer_binding.dart';
import 'package:elingk/modules/field_officer/controllers/field_officer_assignments_controller.dart';
import 'package:elingk/modules/field_officer/views/complaints/field_officer_complaints_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldOfficerRecentComplaints extends StatefulWidget {
  const FieldOfficerRecentComplaints({super.key});

  @override
  State<FieldOfficerRecentComplaints> createState() =>
      _FieldOfficerRecentComplaintsState();
}

class _FieldOfficerRecentComplaintsState
    extends State<FieldOfficerRecentComplaints> {
  late final FieldOfficerAssignmentsController controller;

  @override
  void initState() {
    super.initState();

    FieldOfficerBinding().dependencies();
    controller = Get.find<FieldOfficerAssignmentsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Tugas Terbaru',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Get.to(() => const FieldOfficerComplaintsView()),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.isLoading.value && controller.assignments.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(28),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              ),
            );
          }

          if (controller.error.value != null &&
              controller.assignments.isEmpty) {
            return _MessageCard(
              icon: Icons.cloud_off_outlined,
              title: 'Gagal memuat tugas',
              message: controller.error.value!,
              actionLabel: 'Coba Lagi',
              onAction: controller.loadAssignments,
            );
          }

          if (controller.assignments.isEmpty) {
            return const _MessageCard(
              icon: Icons.assignment_outlined,
              title: 'Belum ada tugas',
              message:
                  'Pengaduan yang ditugaskan kepada Anda akan tampil di sini.',
            );
          }

          final recent = controller.assignments.take(3).toList();

          return Column(
            children: [
              for (var i = 0; i < recent.length; i++) ...[
                _AssignmentCard(assignment: recent[i]),
                if (i < recent.length - 1) const SizedBox(height: 10),
              ],
            ],
          );
        }),
      ],
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.assignment});

  final Map<String, dynamic> assignment;

  String _value(dynamic value, [String fallback = '-']) {
    if (value == null || value.toString().trim().isEmpty) {
      return fallback;
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Mendukung respons assignment yang membungkus data pengaduan
    // di properti "complaint" maupun "pengaduan".
    final complaint = assignment['complaint'] ?? assignment['pengaduan'];

    final complaintData = complaint is Map
        ? Map<String, dynamic>.from(complaint)
        : assignment;

    final nomor = _value(complaintData['nomor_pengaduan'], 'Pengaduan');
    final judul = _value(complaintData['judul'], 'Tanpa judul');
    final status = _value(
      assignment['status'] ?? complaintData['status'],
      'Belum diketahui',
    );

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => Get.to(() => const FieldOfficerComplaintsView()),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: AppColors.navy,
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
                        color: AppColors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      status.replaceAll('_', ' '),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 38, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
