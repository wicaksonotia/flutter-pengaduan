import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/views/complaints/complaint_helpers.dart';
import 'package:flutter/material.dart';

class ComplaintDetailHeader extends StatelessWidget {
  const ComplaintDetailHeader({
    super.key,
    required this.nomorPengaduan,
    required this.status,
    required this.submittedAt,
  });

  final dynamic nomorPengaduan;
  final dynamic status;
  final dynamic submittedAt;

  String _text(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = ComplaintHelpers.statusColor(status);

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOMOR PENGADUAN',
            style: TextStyle(
              color: AppColors.blueLight,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _text(nomorPengaduan),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  ComplaintHelpers.statusLabel(status),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.blueLight,
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Diajukan ${ComplaintHelpers.formatDateTime(submittedAt)}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
