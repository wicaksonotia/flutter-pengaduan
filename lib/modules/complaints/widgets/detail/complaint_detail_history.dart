import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/complaints/complaint_helpers.dart';
import 'package:flutter/material.dart';

import 'complaint_detail_section.dart';

class ComplaintDetailHistory extends StatelessWidget {
  const ComplaintDetailHistory({super.key, required this.histories});

  final List<Map<String, dynamic>> histories;

  @override
  Widget build(BuildContext context) {
    return ComplaintDetailSection(
      title: 'Riwayat Pengaduan',
      icon: Icons.timeline_rounded,
      child: histories.isEmpty
          ? const Text(
              'Riwayat perkembangan belum tersedia.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                height: 1.6,
              ),
            )
          : Column(
              children: histories.asMap().entries.map((entry) {
                final index = entry.key;
                final history = entry.value;

                final status =
                    history['status_baru'] ??
                    history['status'] ??
                    history['status_tujuan'];

                final date = history['created_at'] ?? history['tanggal'];

                final note =
                    history['catatan'] ??
                    history['keterangan'] ??
                    history['deskripsi'];

                return _historyItem(
                  status: status,
                  date: date,
                  note: note,
                  isLast: index == histories.length - 1,
                );
              }).toList(),
            ),
    );
  }

  Widget _historyItem({
    required dynamic status,
    required dynamic date,
    required dynamic note,
    required bool isLast,
  }) {
    final color = ComplaintHelpers.statusColor(status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.18),
                      width: 4,
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
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ComplaintHelpers.statusLabel(status),
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ComplaintHelpers.formatDateTime(date),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  if (note != null && note.toString().trim().isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      note.toString(),
                      style: const TextStyle(
                        color: AppColors.textBody,
                        fontSize: 12,
                        height: 1.5,
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
