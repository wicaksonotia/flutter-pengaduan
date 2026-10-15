import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UnitDelegationDialog extends StatefulWidget {
  const UnitDelegationDialog({super.key, required this.units, this.selectedId});

  final List<Map<String, dynamic>> units;
  final int? selectedId;

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required List<Map<String, dynamic>> units,
    int? selectedId,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) =>
          UnitDelegationDialog(units: units, selectedId: selectedId),
    );
  }

  @override
  State<UnitDelegationDialog> createState() => _UnitDelegationDialogState();
}

class _UnitDelegationDialogState extends State<UnitDelegationDialog> {
  final formKey = GlobalKey<FormState>();
  final catatanController = TextEditingController();
  final searchController = TextEditingController();

  int? selectedId;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.trim().toLowerCase();
    });
  }

  int? _idOf(Map<String, dynamic> item) {
    final value = item['id'];

    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '');
  }

  String _nameOf(Map<String, dynamic> item) {
    return (item['nama'] ??
            item['name'] ??
            item['nama_unit'] ??
            'Unit ${item['id'] ?? ''}')
        .toString();
  }

  String _codeOf(Map<String, dynamic> item) {
    return (item['kode'] ?? item['kode_unit'] ?? item['code'] ?? '').toString();
  }

  bool _isActive(Map<String, dynamic> item) {
    final value = item['aktif'];

    if (value == null) return true;
    if (value is bool) return value;
    if (value is num) return value == 1;

    return value.toString() == '1' || value.toString().toLowerCase() == 'true';
  }

  @override
  Widget build(BuildContext context) {
    final activeUnits = widget.units.where(_isActive).toList();

    final filteredUnits = activeUnits.where((item) {
      final name = _nameOf(item).toLowerCase();
      final code = _codeOf(item).toLowerCase();

      return name.contains(searchQuery) || code.contains(searchQuery);
    }).toList();

    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        width: double.infinity,
        height: screenHeight * 0.82,
        child: Column(
          children: [
            // Handle bottom sheet
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 12, 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_tree_outlined,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delegasikan Pengaduan',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pilih unit yang akan menangani pengaduan.',
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.divider),

            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: TextField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Cari nama atau kode unit...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          onPressed: searchController.clear,
                          icon: const Icon(Icons.close),
                        ),
                  filled: true,
                  fillColor: AppColors.surfaceSoft,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.blue),
                  ),
                ),
              ),
            ),

            // Unit count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Unit tersedia',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${filteredUnits.length} unit',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Unit list
            Expanded(
              child: activeUnits.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Tidak ada unit aktif yang tersedia.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  : filteredUnits.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 36,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Unit tidak ditemukan.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RadioGroup<int>(
                      groupValue: selectedId,
                      onChanged: (value) {
                        setState(() {
                          selectedId = value;
                        });
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        itemCount: filteredUnits.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final item = filteredUnits[index];
                          final id = _idOf(item);

                          if (id == null) {
                            return const SizedBox.shrink();
                          }

                          final selected = selectedId == id;
                          final code = _codeOf(item);

                          return Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.blue.withValues(alpha: 0.07)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? AppColors.blue
                                    : AppColors.border,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              clipBehavior: Clip.antiAlias,
                              child: RadioListTile<int>(
                                value: id,
                                activeColor: AppColors.blue,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                title: Text(
                                  _nameOf(item),
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                subtitle: code.isEmpty
                                    ? null
                                    : Text(
                                        code,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // Note field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                controller: catatanController,
                minLines: 1,
                maxLines: 2,
                maxLength: 2000,
                decoration: InputDecoration(
                  labelText: 'Catatan untuk unit (opsional)',
                  hintText: 'Instruksi tindak lanjut...',
                  counterText: '',
                  prefixIcon: const Icon(
                    Icons.notes_outlined,
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceSoft,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.blue),
                  ),
                ),
              ),
            ),

            // Actions
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                4,
                20,
                16 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: selectedId == null
                          ? null
                          : () {
                              Navigator.pop(context, {
                                'unit_id': selectedId,
                                'catatan': catatanController.text.trim(),
                              });
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: AppColors.textOnPrimary,
                        disabledBackgroundColor: AppColors.surfaceMuted,
                        disabledForegroundColor: AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.send_outlined, size: 18),
                      label: const Text('Delegasikan'),
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
}
