import 'package:flutter/material.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/constants/complaint_status.dart';

class SharedComplaintCard extends StatelessWidget {
  const SharedComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
    this.showUnit = true,
  });

  final Map<String, dynamic> complaint;
  final VoidCallback onTap;
  final bool showUnit;

  String _text(dynamic value, [String fallback = '-']) {
    if (value == null) return fallback;

    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  @override
  Widget build(BuildContext context) {
    final nomor = _text(complaint['nomor_pengaduan'], 'Tanpa nomor');
    final judul = _text(complaint['judul'], 'Pengaduan tanpa judul');
    final status = _text(complaint['status'], '');
    final isi = _text(complaint['isi_pengaduan'], '');
    final createdAt = _text(
      complaint['diajukan_pada'] ?? complaint['created_at'],
      '',
    );

    final unitData = complaint['unit'];
    final unit = unitData is Map ? _text(unitData['nama'], '') : '';

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
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
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusLabel(status: status),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                judul,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (isi.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  isi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
              if (showUnit && unit.isNotEmpty) ...[
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.account_balance_outlined, text: unit),
              ],
              if (createdAt.isNotEmpty)
                _InfoRow(icon: Icons.schedule_outlined, text: createdAt),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Lihat detail  →',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        ComplaintStatus.labelOf(status),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
