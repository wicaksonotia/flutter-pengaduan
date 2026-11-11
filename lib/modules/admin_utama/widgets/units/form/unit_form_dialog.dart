import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:sigapkawan/app/data/models/unit_model.dart';
import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_utama/controllers/admin_utama_units_controller.dart';

import 'unit_form_fields.dart';
import 'unit_form_status.dart';

class UnitFormDialog {
  static Future<void> show({
    UnitModel? unit,
    required AdminUtamaUnitsController controller,
  }) async {
    await Get.dialog(
      Dialog(
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: _UnitFormContent(unit: unit, controller: controller),
      ),
      barrierDismissible: false,
    );
  }
}

class _UnitFormContent extends StatefulWidget {
  const _UnitFormContent({this.unit, required this.controller});

  final UnitModel? unit;
  final AdminUtamaUnitsController controller;

  @override
  State<_UnitFormContent> createState() => _UnitFormContentState();
}

class _UnitFormContentState extends State<_UnitFormContent> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _kodeController;
  late final TextEditingController _namaController;
  late final TextEditingController _deskripsiController;
  late final TextEditingController _alamatController;
  late final TextEditingController _teleponController;

  bool _aktif = true;

  bool get isEdit => widget.unit != null;

  @override
  void initState() {
    super.initState();

    final unit = widget.unit;

    _kodeController = TextEditingController(text: unit?.kode ?? '');
    _namaController = TextEditingController(text: unit?.nama ?? '');
    _deskripsiController = TextEditingController(text: unit?.deskripsi ?? '');
    _alamatController = TextEditingController(text: unit?.alamat ?? '');
    _teleponController = TextEditingController(text: unit?.telepon ?? '');

    _aktif = unit?.aktif ?? true;
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _deskripsiController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Informasi Utama'),
                    const SizedBox(height: 14),

                    UnitFormFields.build(
                      controller: _kodeController,
                      label: 'Kode Unit',
                      hint: 'Contoh: UNIT-001',
                      icon: Icons.tag_rounded,
                      required: true,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 14),

                    UnitFormFields.build(
                      controller: _namaController,
                      label: 'Nama Unit',
                      hint: 'Masukkan nama unit',
                      icon: Icons.business_outlined,
                      required: true,
                    ),

                    const SizedBox(height: 22),
                    _sectionTitle('Informasi Tambahan'),
                    const SizedBox(height: 14),

                    UnitFormFields.build(
                      controller: _deskripsiController,
                      label: 'Deskripsi',
                      hint: 'Deskripsi unit (opsional)',
                      icon: Icons.notes_rounded,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 14),

                    UnitFormFields.build(
                      controller: _alamatController,
                      label: 'Alamat',
                      hint: 'Alamat unit',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 14),

                    UnitFormFields.build(
                      controller: _teleponController,
                      label: 'Telepon',
                      hint: 'Nomor telepon',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    UnitFormStatus(
                      value: _aktif,
                      onChanged: (value) {
                        setState(() => _aktif = value);
                      },
                    ),

                    const SizedBox(height: 24),
                    _buildActions(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isEdit ? Icons.edit_outlined : Icons.add_business_outlined,
              color: AppColors.blue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Unit' : 'Tambah Unit',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isEdit
                      ? 'Perbarui informasi unit'
                      : 'Lengkapi informasi unit baru',
                  style: TextStyle(
                    color: AppColors.navy.withValues(alpha: 0.55),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: widget.controller.isSaving.value
                  ? null
                  : () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 17,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Obx(() {
      final isSaving = widget.controller.isSaving.value;

      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSaving ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.9),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
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
              onPressed: isSaving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.6),
                padding: const EdgeInsets.symmetric(vertical: 14),
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
                        'Menyimpan...',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : Text(
                      isEdit ? 'Simpan Perubahan' : 'Simpan Unit',
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = <String, dynamic>{
      'kode': _kodeController.text.trim().toUpperCase(),
      'nama': _namaController.text.trim(),
      'deskripsi': _deskripsiController.text.trim().isEmpty
          ? null
          : _deskripsiController.text.trim(),
      'alamat': _alamatController.text.trim().isEmpty
          ? null
          : _alamatController.text.trim(),
      'telepon': _teleponController.text.trim().isEmpty
          ? null
          : _teleponController.text.trim(),
      'aktif': _aktif,
    };

    final success = await widget.controller.saveUnit(
      id: widget.unit?.id,
      data: data,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    }
  }
}
