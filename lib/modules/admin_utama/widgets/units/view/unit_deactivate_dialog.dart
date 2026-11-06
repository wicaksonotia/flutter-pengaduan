import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:sapahub/app/data/models/unit_model.dart';
import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/admin_utama/controllers/admin_utama_units_controller.dart';

class UnitStatusDialog {
  static Future<void> show({
    required UnitModel unit,
    required AdminUtamaUnitsController controller,
  }) async {
    final isActive = unit.aktif;

    await Get.dialog(
      Dialog(
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: _UnitStatusDialogContent(
          unit: unit,
          controller: controller,
          isActive: isActive,
        ),
      ),
      barrierDismissible: false,
    );
  }
}

class _UnitStatusDialogContent extends StatelessWidget {
  const _UnitStatusDialogContent({
    required this.unit,
    required this.controller,
    required this.isActive,
  });

  final UnitModel unit;
  final AdminUtamaUnitsController controller;
  final bool isActive;

  Color get actionColor => isActive ? AppColors.danger : AppColors.blue;

  IconData get actionIcon => isActive
      ? Icons.pause_circle_outline_rounded
      : Icons.check_circle_outline_rounded;

  String get title => isActive ? 'Nonaktifkan Unit?' : 'Aktifkan Unit?';

  String get description => isActive
      ? 'Unit ini tidak akan dapat digunakan sementara waktu. Kamu masih bisa mengaktifkannya kembali kapan saja.'
      : 'Unit ini akan diaktifkan kembali dan dapat digunakan seperti biasa.';

  String get actionLabel => isActive ? 'Nonaktifkan' : 'Aktifkan';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.navy.withValues(alpha: 0.65),
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          _buildUnitInfo(),
          const SizedBox(height: 24),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: actionColor.withValues(alpha: 0.09),
        shape: BoxShape.circle,
      ),
      child: Icon(actionIcon, color: actionColor, size: 34),
    );
  }

  Widget _buildUnitInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.account_tree_rounded,
              color: AppColors.blue,
              size: 21,
            ),
          ),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  unit.kode,
                  style: TextStyle(
                    color: AppColors.navy.withValues(alpha: 0.55),
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Obx(() {
      final isSaving = controller.isSaving.value;

      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSaving ? null : () => Get.back(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.9),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton(
              onPressed: isSaving ? null : () => _toggleStatus(context),
              style: FilledButton.styleFrom(
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: actionColor.withValues(alpha: 0.6),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isSaving
                  ? Shimmer.fromColors(
                      baseColor: Colors.white.withValues(alpha: 0.5),
                      highlightColor: Colors.white,
                      child: const Text(
                        'Memproses...',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : Text(
                      actionLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }

  Future<void> _toggleStatus(BuildContext context) async {
    final navigator = Navigator.of(context);

    try {
      await controller.toggleUnitStatus(unit);
    } finally {
      if (navigator.mounted) {
        navigator.pop();
      }
    }
  }
}
