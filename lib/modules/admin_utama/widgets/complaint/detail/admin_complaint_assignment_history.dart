import 'package:elingk/app/utils/image_url_helper.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_photos.dart';
import 'package:flutter/material.dart';

class AdminComplaintAssignmentHistory extends StatelessWidget {
  const AdminComplaintAssignmentHistory({super.key, required this.assignments});

  final List<Map<String, dynamic>> assignments;

  @override
  Widget build(BuildContext context) {
    final items = assignments.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    items.sort((a, b) {
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

    final latestId = items.isEmpty
        ? null
        : int.tryParse('${items.last['id'] ?? ''}');

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

        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final assignment = entry.value;

          final assignmentId = int.tryParse('${assignment['id'] ?? ''}');

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : 14,
            ),
            child: _AssignmentCard(
              assignment: assignment,
              isLatest: assignmentId != null && assignmentId == latestId,
            ),
          );
        }),
      ],
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.assignment, required this.isLatest});

  final Map<String, dynamic> assignment;
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

    final photos = _mapList(
      assignment['evidence_photos'] ?? assignment['evidencePhotos'],
    );

    final responses = _mapList(assignment['responses']);

    final completedAt = assignment['selesai_pada'];
    final isCompleted = completedAt != null && '$completedAt'.isNotEmpty;

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
          _buildHeader(
            context,
            officerName: officerName,
            assignmentId: assignment['id'],
          ),

          const SizedBox(height: 14),

          Divider(color: colors.outlineVariant),

          const SizedBox(height: 12),

          _infoRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'Tanggal penugasan',
            value: _formatDate(assignment['ditugaskan_pada']),
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
              value: _formatDate(completedAt),
            ),
          ],

          const SizedBox(height: 16),

          _sectionLabel('Catatan Penugasan'),

          const SizedBox(height: 6),

          _description(
            context,
            assignment['catatan'],
            'Tidak ada catatan penugasan.',
          ),

          const SizedBox(height: 16),

          Divider(color: colors.outlineVariant),

          const SizedBox(height: 12),

          _sectionLabel('Hasil Penanganan'),

          const SizedBox(height: 8),

          if (!isCompleted)
            _message(context, 'Petugas belum mengirim hasil penanganan.')
          else if (responses.isEmpty)
            _message(context, 'Respons hasil penanganan tidak ditemukan.')
          else
            ...responses.map((response) {
              final isPublic =
                  response['untuk_publik'] == true ||
                  response['untuk_publik'] == 1 ||
                  response['untuk_publik'] == '1';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _responseCard(
                  context,
                  response: response,
                  isPublic: isPublic,
                ),
              );
            }),

          if (isCompleted && photos.isNotEmpty) ...[
            const SizedBox(height: 4),
            _sectionLabel('Foto Bukti Penanganan'),
            const SizedBox(height: 10),
            ComplaintDetailPhotos(
              photos: photos,
              resolveImageUrl: ImageUrlHelper.resolve,
            ),
          ] else if (isCompleted) ...[
            const SizedBox(height: 8),
            _message(context, 'Belum ada foto bukti penanganan.'),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String officerName,
    required dynamic assignmentId,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Row(
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
                'Penugasan #${assignmentId ?? '-'}',
                style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),

        if (isLatest)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Terbaru',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _responseCard(
    BuildContext context, {
    required Map<String, dynamic> response,
    required bool isPublic,
  }) {
    final colors = Theme.of(context).colorScheme;
    final user = response['user'];
    final userName = user is Map ? '${user['name'] ?? '-'}' : 'Petugas';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                isPublic ? 'Publik' : 'Internal',
                style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Text(
            _textOrFallback(response['isi'], 'Isi respons tidak tersedia.'),
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),

          if (response['created_at'] != null) ...[
            const SizedBox(height: 8),
            Text(
              _formatDate(response['created_at']),
              style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant),
            ),
          ],
        ],
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

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );
  }

  Widget _description(BuildContext context, dynamic value, String fallback) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      _textOrFallback(value, fallback),
      style: TextStyle(fontSize: 13, height: 1.5, color: colors.onSurface),
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
          const Icon(Icons.info_outline, size: 17),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
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

    String two(int number) => number.toString().padLeft(2, '0');

    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}
