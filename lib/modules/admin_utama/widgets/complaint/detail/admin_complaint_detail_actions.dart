import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_complaint_detail_controller.dart';
import 'package:elingk/modules/admin_utama/widgets/complaint/detail/complaint_rejection_dialog.dart';
import 'package:elingk/modules/admin_utama/widgets/complaint/detail/unit_delegation_dialog.dart';
import 'package:flutter/material.dart';

class AdminComplaintDetailActions extends StatelessWidget {
  const AdminComplaintDetailActions({super.key, required this.controller});

  final AdminComplaintDetailController controller;

  int? _intValue(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  Future<void> _delegate(BuildContext context) async {
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

      if (context.mounted) {
        _showMessage(context, 'Pengaduan berhasil didelegasikan.');
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, controller.errorMessage(e), isError: true);
      }
    }
  }

  // Penolakan pengaduan pada pemeriksaan awal.
  Future<void> _reject(BuildContext context) async {
    final reason = await ComplaintRejectionDialog.show(context);

    if (reason == null || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Konfirmasi Penolakan',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Pengaduan akan ditolak dan statusnya berubah menjadi ditolak. '
          'Tindakan ini tidak dapat dibatalkan melalui proses pemeriksaan awal.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Kembali',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.textOnPrimary,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Tolak'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await controller.reject(reason);

      if (context.mounted) {
        _showMessage(context, 'Pengaduan berhasil ditolak.');
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, controller.errorMessage(e), isError: true);
      }
    }
  }

  // Persetujuan hasil penanganan Admin Unit.
  Future<void> _approveVerification(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.verified_outlined, color: AppColors.success),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Setujui Hasil Penanganan',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        content: const Text(
          'Apakah kamu yakin hasil penanganan pengaduan ini sudah sesuai? '
          'Jika disetujui, pengaduan akan dinyatakan selesai dan ditutup.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Periksa Kembali',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.textOnPrimary,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Ya, Setujui'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await controller.verify(keputusan: 'disetujui');

      if (context.mounted) {
        _showMessage(
          context,
          'Hasil penanganan disetujui. Pengaduan telah ditutup.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, controller.errorMessage(e), isError: true);
      }
    }
  }

  // Penolakan hasil penanganan Admin Unit.
  Future<void> _rejectVerification(BuildContext context) async {
    final reason = await ComplaintRejectionDialog.show(context);

    if (reason == null || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Konfirmasi Pengembalian',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Hasil penanganan akan ditolak. Pengaduan akan dikembalikan '
          'ke Admin Unit untuk ditindaklanjuti kembali.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Kembali',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.textOnPrimary,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Kembalikan'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await controller.verify(keputusan: 'ditolak', catatan: reason);

      if (context.mounted) {
        _showMessage(
          context,
          'Hasil penanganan ditolak dan dikembalikan ke Admin Unit.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, controller.errorMessage(e), isError: true);
      }
    }
  }

  void _showMessage(
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

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    bool outlined = false,
    bool danger = false,
    bool success = false,
  }) {
    final color = danger
        ? AppColors.danger
        : success
        ? AppColors.success
        : AppColors.blue;

    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.textOnPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = controller.complaint.value!;
    final status = data['status']?.toString() ?? '';

    final canManage = controller.canManageComplaint;
    final canVerify = controller.canVerifyComplaint;
    final isLoading = controller.actionLoading.value;

    final unitName = data['unit'] is Map
        ? (data['unit']['nama'] ?? data['unit']['name'] ?? 'Unit ditentukan')
              .toString()
        : 'Belum ditentukan';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tindakan Admin Utama',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            canVerify
                ? 'Periksa hasil penanganan dari Admin Unit sebelum menyelesaikan pengaduan.'
                : 'Tinjau pengaduan dan tentukan tindakan yang diperlukan.',
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),

          _InfoRow(label: 'Unit tujuan', value: unitName),

          const SizedBox(height: 16),

          if (canManage) ...[
            SizedBox(
              width: double.infinity,
              child: _actionButton(
                label: 'Delegasikan ke Unit',
                icon: Icons.assignment_turned_in_outlined,
                onPressed: isLoading ? null : () => _delegate(context),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: _actionButton(
                label: 'Tolak Pengaduan',
                icon: Icons.block_outlined,
                outlined: true,
                danger: true,
                onPressed: isLoading ? null : () => _reject(context),
              ),
            ),
          ] else if (canVerify) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.fact_check_outlined, color: AppColors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pengaduan menunggu keputusan verifikasi Admin Utama. '
                      'Pastikan hasil penanganan dan bukti pendukung sudah diperiksa.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: _actionButton(
                label: 'Setujui Hasil Penanganan',
                icon: Icons.check_circle_outline,
                success: true,
                onPressed: isLoading
                    ? null
                    : () => _approveVerification(context),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: _actionButton(
                label: 'Tolak Hasil Penanganan',
                icon: Icons.assignment_return_outlined,
                outlined: true,
                danger: true,
                onPressed: isLoading
                    ? null
                    : () => _rejectVerification(context),
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tidak ada tindakan yang tersedia untuk status "$status".',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],

          if (isLoading) ...[
            const SizedBox(height: 14),
            const LinearProgressIndicator(
              minHeight: 3,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Sedang memproses tindakan...',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
