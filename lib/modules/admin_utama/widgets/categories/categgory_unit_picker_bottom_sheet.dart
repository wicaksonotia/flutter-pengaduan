import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UnitPickerBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> units;
  final int? selectedId;

  const UnitPickerBottomSheet({
    super.key,
    required this.units,
    required this.selectedId,
  });

  @override
  State<UnitPickerBottomSheet> createState() => _UnitPickerBottomSheetState();
}

class _UnitPickerBottomSheetState extends State<UnitPickerBottomSheet> {
  late final TextEditingController _searchController;
  late int? _selectedId;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedId = widget.selectedId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();

    final filteredUnits = widget.units.where((unit) {
      final nama = (unit['nama'] ?? '').toString().toLowerCase();
      final kode = (unit['kode'] ?? '').toString().toLowerCase();

      return nama.contains(query) || kode.contains(query);
    }).toList();

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxSheetHeight = screenHeight * 0.75;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: maxSheetHeight,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Drag handle
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 14, 18),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.blueLight.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.account_tree_rounded,
                      color: AppColors.blue,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Unit Tujuan',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Pilih unit yang menangani kategori ini.',
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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _query = value);
                },
                decoration: InputDecoration(
                  hintText: 'Cari nama atau kode unit...',
                  hintStyle: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.iconSecondary,
                    size: 21,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close_rounded, size: 18),
                        ),
                  filled: true,
                  fillColor: AppColors.surfaceSoft,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: AppColors.blue,
                      width: 1.3,
                    ),
                  ),
                ),
              ),
            ),

            // Result count
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Row(
                children: [
                  const Text(
                    'DAFTAR UNIT',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${filteredUnits.length} unit',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Unit list
            Expanded(
              child: filteredUnits.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSoft,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.search_off_rounded,
                                size: 28,
                                color: AppColors.iconSecondary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Unit tidak ditemukan',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Coba kata kunci atau kode unit lainnya.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                      itemCount: filteredUnits.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final unit = filteredUnits[index];
                        final id = _toInt(unit['id']);

                        if (id == null) {
                          return const SizedBox.shrink();
                        }

                        final nama = (unit['nama'] ?? 'Unit tanpa nama')
                            .toString();
                        final kode = (unit['kode'] ?? '').toString();
                        final selected = id == _selectedId;

                        return Material(
                          color: selected
                              ? AppColors.blueLight.withValues(alpha: 0.25)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              setState(() => _selectedId = id);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.blue.withValues(alpha: 0.65)
                                      : AppColors.border.withValues(
                                          alpha: 0.65,
                                        ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? AppColors.blue.withValues(
                                              alpha: 0.10,
                                            )
                                          : AppColors.surfaceSoft,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Icon(
                                      Icons.account_tree_outlined,
                                      color: selected
                                          ? AppColors.blue
                                          : AppColors.iconSecondary,
                                      size: 21,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nama,
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 13,
                                            fontWeight: selected
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                          ),
                                        ),
                                        if (kode.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            kode,
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
                                  Icon(
                                    selected
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: selected
                                        ? AppColors.blue
                                        : AppColors.border,
                                    size: 21,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Sticky confirmation button
            Container(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.7),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _selectedId == null
                        ? null
                        : () => Navigator.of(context).pop(_selectedId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: AppColors.textOnPrimary,
                      disabledBackgroundColor: AppColors.surfaceMuted,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 20),
                    label: const Text(
                      'Pilih Unit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
