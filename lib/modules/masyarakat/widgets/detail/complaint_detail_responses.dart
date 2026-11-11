import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/masyarakat/views/complaints/complaint_helpers.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_section.dart';
import 'package:flutter/material.dart';

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
        children: [
          for (int i = 0; i < responses.length; i++)
            _ResponseItem(
              response: responses[i],
              isLast: i == responses.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ResponseItem extends StatelessWidget {
  const _ResponseItem({required this.response, required this.isLast});

  final Map<String, dynamic> response;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final message =
        response['isi'] ?? response['pesan'] ?? response['isi_tanggapan'];

    final date = response['created_at'];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _displayText(message),
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 13,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 5),
              Text(
                ComplaintHelpers.formatDateTime(date),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _displayText(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }
}
