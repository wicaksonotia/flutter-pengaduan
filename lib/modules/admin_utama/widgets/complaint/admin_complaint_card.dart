import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminComplaintCard extends StatelessWidget {
  final Map<String, dynamic> complaint;
  final VoidCallback onTap;

  const AdminComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });

  String _text(dynamic value, [String fallback = '-']) {
    if (value == null || '$value'.trim().isEmpty) {
      return fallback;
    }

    return '$value';
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  String _statusLabel(String status) {
    const labels = {
      'diajukan': 'Diajukan',
      'ditugaskan': 'Ditugaskan',
      'diproses': 'Diproses',
      'dikembalikan': 'Dikembalikan',
      'menunggu_verifikasi': 'Menunggu verifikasi',
      'menunggu_persetujuan': 'Menunggu persetujuan',
      'selesai': 'Selesai',
      'ditolak': 'Ditolak',
      'ditutup': 'Ditutup',
    };

    return labels[status] ?? status.replaceAll('_', ' ');
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'selesai':
      case 'ditutup':
        return AppColors.success;
      case 'ditolak':
      case 'dikembalikan':
        return AppColors.danger;
      case 'diajukan':
        return AppColors.warning;
      case 'ditugaskan':
      case 'diproses':
        return AppColors.info;
      case 'menunggu_verifikasi':
      case 'menunggu_persetujuan':
        return AppColors.blueDark;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _text(complaint['status'], 'diajukan');
    final user = _asMap(complaint['user']);
    final category = _asMap(complaint['category']);
    final unit = _asMap(complaint['unit']);

    final nomor = _text(
      complaint['nomor_pengaduan'] ?? complaint['nomor'],
      'Pengaduan #${complaint['id'] ?? '-'}',
    );

    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        nomor,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel(status),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  _text(
                    complaint['judul'] ?? complaint['title'],
                    'Pengaduan masyarakat',
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _text(complaint['isi_pengaduan'], 'Tidak ada deskripsi'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),

                const Divider(height: 24, color: AppColors.divider),

                _infoRow(
                  Icons.person_outline,
                  _text(user['name'], 'Pelapor tidak diketahui'),
                ),

                const SizedBox(height: 7),

                _infoRow(
                  Icons.category_outlined,
                  _text(category['nama'], 'Belum ada kategori'),
                ),

                const SizedBox(height: 7),

                _infoRow(
                  Icons.account_tree_outlined,
                  _text(unit['nama'], 'Belum didelegasikan'),
                ),

                const SizedBox(height: 12),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Lihat detail',
                      style: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 16, color: AppColors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.iconSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
