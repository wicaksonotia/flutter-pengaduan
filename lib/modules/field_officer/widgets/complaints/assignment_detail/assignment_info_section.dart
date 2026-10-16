import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'assignment_detail_section.dart';

class AssignmentInfoSection extends StatelessWidget {
  final Map<String, dynamic> complaint;
  final String Function(dynamic, [String]) value;

  const AssignmentInfoSection({
    super.key,
    required this.complaint,
    required this.value,
  });

  Map<String, dynamic> _map(dynamic data) {
    return data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    final category = _map(complaint['category']);
    final unit = _map(complaint['unit']);
    final user = _map(complaint['user']);

    return AssignmentDetailSection(
      title: 'Informasi Pengaduan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value(complaint['nomor_pengaduan']),
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value(complaint['judul'], 'Tanpa judul'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          AssignmentInfoRow(label: 'Status', value: value(complaint['status'])),
          AssignmentInfoRow(label: 'Kategori', value: value(category['nama'])),
          AssignmentInfoRow(label: 'Unit', value: value(unit['nama'])),
          AssignmentInfoRow(label: 'Pelapor', value: value(user['name'])),
          const Divider(height: 24),
          const Text(
            'Deskripsi',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(value(complaint['deskripsi'])),
        ],
      ),
    );
  }
}
