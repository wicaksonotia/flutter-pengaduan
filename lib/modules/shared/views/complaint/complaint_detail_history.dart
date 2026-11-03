import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/views/complaints/complaint_helpers.dart';
import 'package:flutter/material.dart';

import 'expandable_detail_section.dart';

class ComplaintDetailHistory extends StatefulWidget {
  const ComplaintDetailHistory({super.key, required this.histories});

  final List<Map<String, dynamic>> histories;

  @override
  State<ComplaintDetailHistory> createState() => _ComplaintDetailHistoryState();
}

class _ComplaintDetailHistoryState extends State<ComplaintDetailHistory> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final histories = widget.histories;

    final startIndex = showAll || histories.length <= 3
        ? 0
        : histories.length - 3;

    final visibleHistories = histories.skip(startIndex).toList();

    return ExpandableDetailSection(
      title: 'Riwayat Pengaduan',
      icon: Icons.timeline_rounded,
      accentColor: AppColors.purple,
      subtitle: histories.isEmpty
          ? 'Belum ada perkembangan'
          : '${histories.length} riwayat perkembangan',
      initiallyExpanded: true,
      child: Column(
        children: [
          if (histories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Riwayat perkembangan belum tersedia.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            )
          else ...[
            ...visibleHistories.asMap().entries.map((entry) {
              final history = entry.value;
              final originalIndex = startIndex + entry.key;

              final status =
                  history['status_baru'] ??
                  history['status'] ??
                  history['status_tujuan'];

              final date = history['created_at'] ?? history['tanggal'];

              final note =
                  history['catatan'] ??
                  history['keterangan'] ??
                  history['deskripsi'];

              return _HistoryItem(
                status: status,
                date: date,
                note: note,
                isLast: originalIndex == histories.length - 1,
              );
            }),

            if (histories.length > 3) ...[
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() => showAll = !showAll);
                  },
                  icon: Icon(
                    showAll
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.history_rounded,
                    size: 18,
                  ),
                  label: Text(
                    showAll
                        ? 'Tampilkan lebih sedikit'
                        : 'Lihat semua ${histories.length} riwayat',
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.blue,
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.status,
    required this.date,
    required this.note,
    required this.isLast,
  });

  final dynamic status;
  final dynamic date;
  final dynamic note;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = ComplaintHelpers.statusColor(status);
    final hasNote = note != null && note.toString().trim().isNotEmpty;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 23,
            child: Column(
              children: [
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.18),
                      width: 3,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: AppColors.divider),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 11),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLast
                    ? color.withValues(alpha: 0.07)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: isLast
                      ? color.withValues(alpha: 0.18)
                      : AppColors.border.withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ComplaintHelpers.statusLabel(status),
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (isLast)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Terbaru',
                            style: TextStyle(
                              color: color,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          ComplaintHelpers.formatDateTime(date),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hasNote) ...[
                    const SizedBox(height: 7),
                    Text(
                      note.toString(),
                      style: const TextStyle(
                        color: AppColors.textBody,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
