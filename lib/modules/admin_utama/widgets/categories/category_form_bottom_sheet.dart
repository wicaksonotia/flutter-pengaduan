import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_complaint_categories_controller.dart';
import 'package:elingk/modules/admin_utama/widgets/categories/categgory_unit_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryFormBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? category;

  const CategoryFormBottomSheet({super.key, this.category});

  static Future<void> show(
    BuildContext context, {
    Map<String, dynamic>? category,
  }) async {
    final controller = Get.find<AdminComplaintCategoriesController>();

    if (category == null) {
      controller.prepareCreate();
    } else {
      controller.prepareEdit(category);
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => CategoryFormBottomSheet(category: category),
    );
  }

  @override
  State<CategoryFormBottomSheet> createState() =>
      _CategoryFormBottomSheetState();
}

class _CategoryFormBottomSheetState extends State<CategoryFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final AdminComplaintCategoriesController controller;

  bool get isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AdminComplaintCategoriesController>();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    if (controller.isSaving.value) return;

    final success = await controller.saveCategory();

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isEditing
                          ? Icons.edit_note_rounded
                          : Icons.create_new_folder_outlined,
                      color: AppColors.textOnPrimary,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Kategori' : 'Tambah Kategori',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Lengkapi informasi kategori pengaduan.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: controller.isSaving.value
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Nama kategori', required: true),
                      const SizedBox(height: 9),
                      TextFormField(
                        controller: controller.namaController,
                        autofocus: true,
                        maxLength: 150,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama kategori wajib diisi.';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          hint: 'Contoh: Infrastruktur Jalan',
                          icon: Icons.category_outlined,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Unit tujuan
                      _buildLabel('Unit tujuan', required: true),
                      const SizedBox(height: 9),
                      _buildUnitPicker(),

                      const SizedBox(height: 20),

                      // Deskripsi
                      _buildLabel('Deskripsi'),
                      const SizedBox(height: 9),
                      TextFormField(
                        controller: controller.deskripsiController,
                        maxLines: 4,
                        minLines: 3,
                        maxLength: 2000,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _inputDecoration(
                          hint: 'Jelaskan jenis pengaduan dalam kategori ini',
                          icon: Icons.subject_rounded,
                          alignIconTop: true,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Status aktif/nonaktif
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: controller.selectedActive.value
                                      ? Colors.green.withValues(alpha: 0.10)
                                      : AppColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  controller.selectedActive.value
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.pause_circle_outline_rounded,
                                  color: controller.selectedActive.value
                                      ? Colors.green.shade700
                                      : AppColors.iconSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.selectedActive.value
                                          ? 'Kategori aktif'
                                          : 'Kategori nonaktif',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.selectedActive.value
                                          ? 'Kategori dapat digunakan untuk '
                                                'pengelolaan pengaduan.'
                                          : 'Kategori dinonaktifkan untuk '
                                                'penggunaan baru.',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: controller.selectedActive.value,
                                activeTrackColor: AppColors.blue,
                                onChanged: controller.isSaving.value
                                    ? null
                                    : controller.setSelectedActive,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.info,
                              size: 19,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Setiap kategori terhubung ke satu unit '
                                'tujuan. Admin Utama menetapkan kategori '
                                'pengaduan agar pengaduan dapat diarahkan '
                                'ke unit yang sesuai.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => ElevatedButton.icon(
                        onPressed: controller.isSaving.value ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: AppColors.textOnPrimary,
                          disabledBackgroundColor: AppColors.surfaceMuted,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: controller.isSaving.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textOnPrimary,
                                ),
                              )
                            : const Icon(Icons.check_rounded, size: 19),
                        label: Text(
                          controller.isSaving.value
                              ? 'Menyimpan...'
                              : isEditing
                              ? 'Simpan Perubahan'
                              : 'Simpan Kategori',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  BoxDecoration _fieldBoxDecoration() {
    return BoxDecoration(
      color: AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );
  }

  Widget _buildLabel(String label, {bool required = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    bool alignIconTop = false,
  }) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 12),
      prefixIcon: Padding(
        padding: EdgeInsets.only(bottom: alignIconTop ? 54 : 0),
        child: Icon(icon, size: 20, color: AppColors.iconSecondary),
      ),
      filled: true,
      fillColor: AppColors.surfaceSoft,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      counterStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
      border: outline,
      enabledBorder: outline,
      focusedBorder: outline.copyWith(
        borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
      ),
      errorBorder: outline.copyWith(
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: outline.copyWith(
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
    );
  }

  Widget _buildUnitPicker() {
    return FormField<int>(
      initialValue: controller.selectedUnitId.value,
      validator: (value) {
        if (controller.selectedUnitId.value == null) {
          return 'Unit tujuan wajib dipilih.';
        }
        return null;
      },
      builder: (field) {
        return Obx(() {
          final selectedId = controller.selectedUnitId.value;

          Map<String, dynamic>? selectedUnit;
          for (final unit in controller.units) {
            if (_toInt(unit['id']) == selectedId) {
              selectedUnit = unit;
              break;
            }
          }

          if (controller.isLoadingUnits.value && controller.units.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: _fieldBoxDecoration(),
              child: const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Memuat daftar unit...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.units.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: _fieldBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar unit belum tersedia.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: controller.isLoadingUnits.value
                        ? null
                        : controller.fetchUnits,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Muat ulang unit'),
                  ),
                ],
              ),
            );
          }

          final selectedName = selectedUnit == null
              ? 'Pilih unit tujuan'
              : (selectedUnit['nama'] ?? 'Unit tanpa nama').toString();

          final selectedCode = (selectedUnit?['kode'] ?? '').toString();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: controller.isSaving.value
                    ? null
                    : () async {
                        final pickedId = await _showUnitPicker();

                        if (pickedId != null && mounted) {
                          controller.setSelectedUnit(pickedId);
                          field.didChange(pickedId);
                          field.validate();
                        }
                      },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: field.hasError
                          ? AppColors.danger
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_tree_outlined,
                        color: AppColors.iconSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedName,
                              style: TextStyle(
                                color: selectedUnit == null
                                    ? AppColors.textHint
                                    : AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: selectedUnit == null
                                    ? FontWeight.normal
                                    : FontWeight.w700,
                              ),
                            ),
                            if (selectedUnit != null &&
                                selectedCode.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Kode: $selectedCode',
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.blue,
                        size: 21,
                      ),
                    ],
                  ),
                ),
              ),
              if (field.hasError) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    field.errorText!,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          );
        });
      },
    );
  }

  Future<int?> _showUnitPicker() {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => UnitPickerBottomSheet(
        units: controller.units.toList(),
        selectedId: controller.selectedUnitId.value,
      ),
    );
  }
}
