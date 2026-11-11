import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_utama/controllers/admin_complaint_detail_controller.dart';
import 'package:sigapkawan/modules/admin_utama/widgets/complaint/detail/admin_complaint_detail_action_handler.dart';
import 'package:flutter/material.dart';

class AdminComplaintDetailActions extends StatelessWidget {
  const AdminComplaintDetailActions({super.key, required this.controller});

  final AdminComplaintDetailController controller;

  @override
  Widget build(BuildContext context) {
    final data = controller.complaint.value;

    if (data == null) {
      return const SizedBox.shrink();
    }

    final status = controller.status ?? '';
    final canManage = controller.canManageComplaint;
    final canVerify = controller.canVerifyComplaint;
    final isLoading = controller.actionLoading.value;

    final unit = data['unit'];

    final unitName = unit is Map
        ? (unit['nama'] ?? unit['name'] ?? 'Unit ditentukan').toString()
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
          _buildHeader(canVerify),
          const SizedBox(height: 16),

          _UnitInfoRow(label: 'Unit tujuan', value: unitName),

          const SizedBox(height: 16),

          if (canManage)
            _buildManagementActions(context, isLoading)
          else if (canVerify)
            _buildVerificationActions(context, isLoading)
          else
            _buildUnavailableStatus(status),

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

  Widget _buildHeader(bool canVerify) {
    return Column(
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
      ],
    );
  }

  Widget _buildManagementActions(BuildContext context, bool isLoading) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _ActionButton(
            label: 'Delegasikan ke Unit',
            icon: Icons.assignment_turned_in_outlined,
            onPressed: isLoading
                ? null
                : () => AdminComplaintDetailActionHandler.delegate(
                    context,
                    controller,
                  ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: _ActionButton(
            label: 'Tolak Pengaduan',
            icon: Icons.block_outlined,
            outlined: true,
            danger: true,
            onPressed: isLoading
                ? null
                : () => AdminComplaintDetailActionHandler.reject(
                    context,
                    controller,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationActions(BuildContext context, bool isLoading) {
    return Column(
      children: [
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
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: _ActionButton(
            label: 'Setujui Hasil Penanganan',
            icon: Icons.check_circle_outline,
            success: true,
            onPressed: isLoading
                ? null
                : () => AdminComplaintDetailActionHandler.approveVerification(
                    context,
                    controller,
                  ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: _ActionButton(
            label: 'Tolak Hasil Penanganan',
            icon: Icons.assignment_return_outlined,
            outlined: true,
            danger: true,
            onPressed: isLoading
                ? null
                : () => AdminComplaintDetailActionHandler.rejectVerification(
                    context,
                    controller,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnavailableStatus(String status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Tidak ada tindakan yang tersedia untuk status "$status".',
        style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
      ),
    );
  }
}

// ===========================================================
// TOMBOL TINDAKAN
// ===========================================================

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.outlined = false,
    this.danger = false,
    this.success = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool danger;
  final bool success;

  Color get color {
    if (danger) return AppColors.danger;
    if (success) return AppColors.success;
    return AppColors.blue;
  }

  @override
  Widget build(BuildContext context) {
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
}

// ===========================================================
// INFORMASI UNIT TUJUAN
// ===========================================================

class _UnitInfoRow extends StatelessWidget {
  const _UnitInfoRow({required this.label, required this.value});

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
