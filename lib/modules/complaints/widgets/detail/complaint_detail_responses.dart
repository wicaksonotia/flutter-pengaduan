import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/complaints/complaint_helpers.dart';
import 'package:flutter/material.dart';

import 'complaint_detail_section.dart';

class ComplaintDetailResponses extends StatelessWidget {
  const ComplaintDetailResponses({super.key, required this.responses});

  final List<Map<String, dynamic>> responses;

  @override
  Widget build(BuildContext context) {
    if (responses.isEmpty) {
      return const SizedBox.shrink();
    }

    return ComplaintDetailSection(
      title: 'Tanggapan Petugas',
      icon: Icons.chat_bubble_outline_rounded,
      child: Column(
        children: responses.map((response) {
          final message =
              response['isi'] ?? response['pesan'] ?? response['isi_tanggapan'];

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _text(message),
                  style: const TextStyle(
                    color: AppColors.textBody,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ComplaintHelpers.formatDateTime(response['created_at']),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _text(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }
}
