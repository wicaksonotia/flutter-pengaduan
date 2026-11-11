import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_utama/controllers/admin_complaint_detail_controller.dart';
import 'package:sigapkawan/modules/admin_utama/widgets/complaint/detail/complaint_rejection_dialog.dart';
import 'package:sigapkawan/modules/admin_utama/widgets/complaint/detail/unit_delegation_dialog.dart';
import 'package:flutter/material.dart';

class AdminComplaintDetailActionHandler {
  AdminComplaintDetailActionHandler._();

  static int? _intValue(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  // =========================================================
  // DELEGASI KE UNIT
  // =========================================================

  static Future<void> delegate(
    BuildContext context,
    AdminComplaintDetailController controller,
  ) async {
    try {
      await controller.loadUnits();

      if (!context.mounted) return;

      if (controller.units.isEmpty) {
        _showMessage(context, 'Belum ada unit yang tersedia.');
        return;
      }

      final result = await UnitDelegationDialog.show(
        context,
        units: controller.units.toList(),
        selectedId: _intValue(controller.complaint.value?['unit_id']),
      );

      if (result == null || !context.mounted) return;

      final unitId = _intValue(result['unit_id']);

      if (unitId == null) {
        _showMessage(context, 'Unit tujuan tidak valid.', isError: true);
        return;
      }

      await controller.delegate(
        unitId: unitId,
        catatan: result['catatan']?.toString(),
      );

      if (!context.mounted) return;

      _showMessage(context, 'Pengaduan berhasil didelegasikan.');
    } catch (e) {
      if (!context.mounted) return;

      _showMessage(context, controller.errorMessage(e), isError: true);
    }
  }

  // =========================================================
  // PENOLAKAN PENGADUAN AWAL
  // =========================================================

  static Future<void> reject(
    BuildContext context,
    AdminComplaintDetailController controller,
  ) async {
    final reason = await ComplaintRejectionDialog.show(context);

    if (reason == null || !context.mounted) return;

    final confirmed = await _showConfirmation(
      context,
      title: 'Konfirmasi Penolakan',
      message:
          'Pengaduan akan ditolak dan statusnya berubah menjadi ditolak. '
          'Tindakan ini tidak dapat dibatalkan melalui proses pemeriksaan awal.',
      confirmLabel: 'Ya, Tolak',
      confirmColor: AppColors.danger,
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await controller.reject(reason);

      if (!context.mounted) return;

      _showMessage(context, 'Pengaduan berhasil ditolak.');
    } catch (e) {
      if (!context.mounted) return;

      _showMessage(context, controller.errorMessage(e), isError: true);
    }
  }

  // =========================================================
  // PERSETUJUAN HASIL PENANGANAN
  // =========================================================

  static Future<void> approveVerification(
    BuildContext context,
    AdminComplaintDetailController controller,
  ) async {
    final confirmed = await _showConfirmation(
      context,
      title: 'Setujui Hasil Penanganan',
      message:
          'Apakah kamu yakin hasil penanganan pengaduan ini sudah sesuai? '
          'Jika disetujui, pengaduan akan dinyatakan selesai dan ditutup.',
      confirmLabel: 'Ya, Setujui',
      confirmColor: AppColors.success,
      confirmIcon: Icons.check_circle_outline,
      titleIcon: Icons.verified_outlined,
      titleIconColor: AppColors.success,
      cancelLabel: 'Periksa Kembali',
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await controller.verify(keputusan: 'disetujui');

      if (!context.mounted) return;

      _showMessage(
        context,
        'Hasil penanganan disetujui. Pengaduan telah ditutup.',
      );
    } catch (e) {
      if (!context.mounted) return;

      _showMessage(context, controller.errorMessage(e), isError: true);
    }
  }

  // =========================================================
  // PENGEMBALIAN HASIL PENANGANAN
  // =========================================================

  static Future<void> rejectVerification(
    BuildContext context,
    AdminComplaintDetailController controller,
  ) async {
    final reason = await ComplaintRejectionDialog.show(context);

    if (reason == null || !context.mounted) return;

    final confirmed = await _showConfirmation(
      context,
      title: 'Konfirmasi Pengembalian',
      message:
          'Hasil penanganan akan ditolak. Pengaduan akan dikembalikan '
          'ke Admin Unit untuk ditindaklanjuti kembali.',
      confirmLabel: 'Ya, Kembalikan',
      confirmColor: AppColors.danger,
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await controller.verify(keputusan: 'ditolak', catatan: reason);

      if (!context.mounted) return;

      _showMessage(
        context,
        'Hasil penanganan ditolak dan dikembalikan ke Admin Unit.',
      );
    } catch (e) {
      if (!context.mounted) return;

      _showMessage(context, controller.errorMessage(e), isError: true);
    }
  }

  // =========================================================
  // DIALOG KONFIRMASI UMUM
  // =========================================================

  static Future<bool?> _showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    String cancelLabel = 'Kembali',
    IconData? confirmIcon,
    IconData? titleIcon,
    Color? titleIconColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              if (titleIcon != null) ...[
                Icon(titleIcon, color: titleIconColor ?? AppColors.blue),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                cancelLabel,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: AppColors.textOnPrimary,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              icon: confirmIcon == null
                  ? const SizedBox.shrink()
                  : Icon(confirmIcon),
              label: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // NOTIFIKASI
  // =========================================================

  static void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.danger : AppColors.navy,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
