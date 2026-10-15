import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_complaint_detail_controller.dart';
import 'package:elingk/modules/admin_utama/widgets/complaint/detail/category_selection_dialog.dart';
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

  int? get _categoryId {
    final data = controller.complaint.value;
    return _intValue(data?['category_id'] ?? data?['category']?['id']);
  }

  Future<void> _selectCategory(BuildContext context) async {
    try {
      await controller.loadCategories();

      if (!context.mounted) return;

      if (controller.categories.isEmpty) {
        _showMessage(context, 'Belum ada kategori yang tersedia.');
        return;
      }

      final categoryId = await CategorySelectionDialog.show(
        context,
        categories: controller.categories.toList(),
        selectedId: _categoryId,
      );

      if (categoryId == null || !context.mounted) return;

      await controller.setCategory(categoryId);

      if (context.mounted) {
        _showMessage(context, 'Kategori berhasil ditentukan.');
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, controller.errorMessage(e), isError: true);
      }
    }
  }

  Future<void> _delegate(BuildContext context) async {
    // if (_categoryId == null) {
    //   _showMessage(
    //     context,
    //     'Tentukan kategori terlebih dahulu sebelum delegasi.',
    //     isError: true,
    //   );
    //   return;
    // }

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
  }) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: danger ? AppColors.danger : AppColors.blue,
          side: BorderSide(color: danger ? AppColors.danger : AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.blue,
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
    final categoryName = data['category'] is Map
        ? (data['category']['nama'] ??
                  data['category']['name'] ??
                  'Kategori ditentukan')
              .toString()
        : 'Belum ditentukan';

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
          const Text(
            'Tinjau kategori dan tentukan unit yang menangani pengaduan.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),
          // _InfoRow(label: 'Kategori', value: categoryName),
          // const SizedBox(height: 10),
          _InfoRow(label: 'Unit tujuan', value: unitName),
          const SizedBox(height: 16),
          if (canManage) ...[
            // SizedBox(
            //   width: double.infinity,
            //   child: _actionButton(
            //     label: 'Tentukan Kategori',
            //     icon: Icons.category_outlined,
            //     outlined: true,
            //     onPressed: controller.actionLoading.value
            //         ? null
            //         : () => _selectCategory(context),
            //   ),
            // ),
            // const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: _actionButton(
                label: 'Delegasikan ke Unit',
                icon: Icons.assignment_turned_in_outlined,
                onPressed: controller.actionLoading.value
                    ? null
                    : () => _delegate(context),
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
                onPressed: controller.actionLoading.value
                    ? null
                    : () => _reject(context),
              ),
            ),
          ] else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tidak ada tindakan pemeriksaan awal untuk status "$status".',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
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
