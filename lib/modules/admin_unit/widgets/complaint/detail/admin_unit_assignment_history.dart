import 'package:elingk/app/utils/image_url_helper.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaint_detail_controller.dart';
import 'package:elingk/modules/admin_unit/widgets/complaint/detail/admin_unit_assignment_review.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_photos.dart';
import 'package:flutter/material.dart';

class AdminUnitAssignmentHistory extends StatelessWidget {
  const AdminUnitAssignmentHistory({super.key, required this.controller});

  final AdminUnitComplaintDetailController controller;

  @override
  Widget build(BuildContext context) {
    final assignments = controller.assignments;

    // Urutkan dari penugasan paling lama ke terbaru.
    assignments.sort((a, b) {
      final dateA = DateTime.tryParse('${a['ditugaskan_pada'] ?? ''}');
      final dateB = DateTime.tryParse('${b['ditugaskan_pada'] ?? ''}');

      final comparison = (dateA ?? DateTime(1970)).compareTo(
        dateB ?? DateTime(1970),
      );

      if (comparison != 0) return comparison;

      final idA = int.tryParse('${a['id'] ?? 0}') ?? 0;
      final idB = int.tryParse('${b['id'] ?? 0}') ?? 0;

      return idA.compareTo(idB);
    });

    final latestId = assignments.isEmpty
        ? null
        : int.tryParse('${assignments.last['id'] ?? ''}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 21),
            SizedBox(width: 9),
            Expanded(
              child: Text(
                'Riwayat Penugasan Petugas Lapangan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...assignments.asMap().entries.map((entry) {
          final index = entry.key;
          final assignment = entry.value;
          final assignmentId = int.tryParse('${assignment['id'] ?? ''}');

          final isLatest = assignmentId != null && assignmentId == latestId;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == assignments.length - 1 ? 0 : 14,
            ),
            child: _AssignmentCard(
              assignment: assignment,
              controller: controller,
              isLatest: isLatest,
            ),
          );
        }),
      ],
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({
    required this.assignment,
    required this.controller,
    required this.isLatest,
  });

  final Map<String, dynamic> assignment;
  final AdminUnitComplaintDetailController controller;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final officer = assignment['user'];
    final assignedBy = assignment['assigned_by'] ?? assignment['assignedBy'];

    final officerName = officer is Map ? '${officer['name'] ?? '-'}' : '-';

    final assignedByName = assignedBy is Map
        ? '${assignedBy['name'] ?? '-'}'
        : '-';

    final finishedAt = assignment['selesai_pada'];
    final assignedAt = assignment['ditugaskan_pada'];

    final photos = controller.mapList(
      assignment['evidence_photos'] ?? assignment['evidencePhotos'],
    );

    // Respons harus berasal dari assignment ini.
    final responses = controller.mapList(assignment['responses']);

    final response = controller.internalResponseFromAssignment(assignment);

    final note = response?['isi'];

    final isCompleted = finishedAt != null && '$finishedAt'.isNotEmpty;

    final canReview = isLatest && controller.canReviewLatestAssignment;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLatest
              ? colors.primary.withValues(alpha: 0.55)
              : colors.outlineVariant,
          width: isLatest ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.engineering_outlined,
                  color: colors.onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      officerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Penugasan #${assignment['id'] ?? '-'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              if (isLatest)
                _statusBadge(context, label: 'Terbaru', color: colors.primary),
            ],
          ),

          const SizedBox(height: 15),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 10),

          _infoRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'Ditugaskan pada',
            value: _formatDate(assignedAt),
          ),

          const SizedBox(height: 10),

          _infoRow(
            context,
            icon: Icons.person_outline,
            label: 'Ditugaskan oleh',
            value: assignedByName,
          ),

          if (isCompleted) ...[
            const SizedBox(height: 10),
            _infoRow(
              context,
              icon: Icons.check_circle_outline,
              label: 'Hasil dikirim pada',
              value: _formatDate(finishedAt),
            ),
          ],

          const SizedBox(height: 14),

          const Text(
            'Catatan Penugasan',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 5),

          Text(
            _textOrFallback(
              assignment['catatan'],
              'Tidak ada catatan penugasan.',
            ),
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 16),

          Divider(color: colors.outlineVariant),

          const SizedBox(height: 12),

          const Text(
            'Hasil Penanganan',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          if (!isCompleted)
            _message(context, 'Petugas belum mengirim hasil penanganan.')
          else ...[
            Text(
              _textOrFallback(note, 'Catatan penanganan tidak ditemukan.'),
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: colors.onSurface,
              ),
            ),

            if (photos.isNotEmpty) ...[
              const SizedBox(height: 14),
              ComplaintDetailPhotos(
                photos: photos,
                resolveImageUrl: ImageUrlHelper.resolve,
              ),
            ] else ...[
              const SizedBox(height: 10),
              _message(context, 'Belum ada foto bukti penanganan.'),
            ],
          ],

          if (isCompleted && responses.isEmpty) ...[
            const SizedBox(height: 8),
            _message(context, 'Respons penugasan belum tersedia.'),
          ],

          if (canReview) ...[
            const SizedBox(height: 16),
            AdminUnitAssignmentReview(controller: controller),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(
    BuildContext context, {
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: colors.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _message(BuildContext context, String message) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 17, color: colors.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  String _textOrFallback(dynamic value, String fallback) {
    if (value == null || '$value'.trim().isEmpty) {
      return fallback;
    }

    return '$value';
  }

  String _formatDate(dynamic value) {
    if (value == null || '$value'.isEmpty) return '-';

    final date = DateTime.tryParse('$value');
    if (date == null) return '$value';

    final local = date.toLocal();

    String two(int value) => value.toString().padLeft(2, '0');

    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}
