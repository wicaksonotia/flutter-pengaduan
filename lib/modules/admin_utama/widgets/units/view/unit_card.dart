import 'package:flutter/material.dart';
import 'package:sigapkawan/app/data/models/unit_model.dart';
import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_utama/widgets/units/view/unit_info_row.dart';
import 'package:sigapkawan/modules/admin_utama/widgets/units/view/unit_status_badge.dart';

class UnitCard extends StatelessWidget {
  const UnitCard({
    super.key,
    required this.unit,
    required this.onTap,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final UnitModel unit;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final isActive = unit.aktif;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.025),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
              child: _buildHeader(isActive),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppColors.border.withValues(alpha: 0.7),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: _buildInformation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isActive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildIcon(isActive),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                unit.nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.tag_rounded,
                    size: 12,
                    color: AppColors.navy.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      unit.kode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  UnitStatusBadge(aktif: isActive),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        _buildMenu(isActive),
      ],
    );
  }

  Widget _buildIcon(bool isActive) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.blue.withValues(alpha: 0.09)
            : AppColors.border.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        Icons.account_tree_rounded,
        size: 23,
        color: isActive
            ? AppColors.blue
            : AppColors.navy.withValues(alpha: 0.45),
      ),
    );
  }

  Widget _buildMenu(bool isActive) {
    return PopupMenuButton<String>(
      tooltip: 'Menu unit',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
      icon: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          color: AppColors.navy.withValues(alpha: 0.7),
          size: 21,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'toggle') {
          onToggleStatus();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: AppColors.blue),
              SizedBox(width: 10),
              Text('Edit Unit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                isActive
                    ? Icons.block_rounded
                    : Icons.check_circle_outline_rounded,
                size: 18,
                color: isActive ? AppColors.danger : AppColors.blue,
              ),
              const SizedBox(width: 10),
              Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInformation() {
    return Column(
      children: [
        UnitInfoRow(
          icon: Icons.account_balance_outlined,
          label: 'Instansi',
          value: unit.instansi?.nama ?? '-',
        ),
        if (unit.alamat?.isNotEmpty == true) ...[
          const SizedBox(height: 11),
          UnitInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Alamat',
            value: unit.alamat!,
          ),
        ],
      ],
    );
  }
}
