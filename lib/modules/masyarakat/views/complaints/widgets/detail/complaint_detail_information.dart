import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'complaint_detail_section.dart';

class ComplaintDetailInformation extends StatelessWidget {
  const ComplaintDetailInformation({
    super.key,
    required this.judul,
    required this.isiPengaduan,
    this.category,
    this.unit,
  });

  final dynamic judul;
  final dynamic isiPengaduan;
  final dynamic category;
  final dynamic unit;

  String _text(dynamic value, {String fallback = '-'}) {
    if (value == null || value.toString().trim().isEmpty) {
      return fallback;
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = category is Map
        ? _text(category['nama'], fallback: '')
        : '';

    final unitName = unit is Map ? _text(unit['nama'], fallback: '') : '';

    return ComplaintDetailSection(
      title: 'Informasi Pengaduan',
      icon: Icons.description_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Judul Laporan',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            _text(judul, fallback: 'Tanpa judul'),
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Isi Pengaduan',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 7),
          Text(
            _text(isiPengaduan, fallback: 'Isi pengaduan belum tersedia.'),
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              height: 1.7,
            ),
          ),
          if (categoryName.isNotEmpty) ...[
            const SizedBox(height: 18),
            _detailRow(Icons.category_outlined, 'Kategori', categoryName),
          ],
          if (unitName.isNotEmpty) ...[
            const SizedBox(height: 12),
            _detailRow(
              Icons.account_balance_outlined,
              'Unit penanganan',
              unitName,
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.textMuted),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
