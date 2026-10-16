import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminUnitFieldOfficerAssignmentSheet extends StatefulWidget {
  const AdminUnitFieldOfficerAssignmentSheet({
    super.key,
    required this.officers,
  });

  final List<Map<String, dynamic>> officers;

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required List<Map<String, dynamic>> officers,
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
      builder: (_) => AdminUnitFieldOfficerAssignmentSheet(officers: officers),
    );
  }

  @override
  State<AdminUnitFieldOfficerAssignmentSheet> createState() =>
      _AdminUnitFieldOfficerAssignmentSheetState();
}

class _AdminUnitFieldOfficerAssignmentSheetState
    extends State<AdminUnitFieldOfficerAssignmentSheet> {
  final catatanController = TextEditingController();

  Map<String, dynamic>? selectedOfficer;

  @override
  void dispose() {
    catatanController.dispose();
    super.dispose();
  }

  int? _idOf(Map<String, dynamic> item) {
    final value = item['id'];
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  String _nameOf(Map<String, dynamic> item) {
    return (item['name'] ?? item['nama'] ?? 'Field Officer').toString();
  }

  String _emailOf(Map<String, dynamic> item) {
    return (item['email'] ?? '').toString();
  }

  String _phoneOf(Map<String, dynamic> item) {
    return (item['phone'] ?? '').toString();
  }

  Future<void> _selectOfficer() async {
    final officer = await AdminUnitFieldOfficerSelectionSheet.show(
      context,
      officers: widget.officers,
      selectedId: _idOf(selectedOfficer ?? {}),
    );

    if (!mounted || officer == null) return;

    setState(() {
      selectedOfficer = officer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxSheetHeight = screenHeight * 0.75;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        width: double.infinity,
        height: maxSheetHeight,
        child: Column(
          children: [
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
                      Icons.assignment_ind_outlined,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teruskan Pengaduan',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pilih petugas yang akan menangani pengaduan.',
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                children: [
                  const Text(
                    'Field Officer',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),

                  InkWell(
                    onTap: _selectOfficer,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selectedOfficer == null
                              ? AppColors.border
                              : AppColors.blue,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.blue.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_search_outlined,
                              color: AppColors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: selectedOfficer == null
                                ? const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pilih Field Officer',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Cari berdasarkan nama, email, atau HP',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _nameOf(selectedOfficer!),
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (_emailOf(selectedOfficer!)
                                          .isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          _emailOf(selectedOfficer!),
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                      if (_phoneOf(selectedOfficer!)
                                          .isNotEmpty) ...[
                                        const SizedBox(height: 3),
                                        Text(
                                          _phoneOf(selectedOfficer!),
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Catatan Penugasan',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: catatanController,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 2000,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Mohon periksa lokasi dan lakukan penanganan.',
                      counterText: '',
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 48),
                        child: Icon(
                          Icons.notes_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceSoft,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
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
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.divider),

            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
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
                      onPressed: _idOf(selectedOfficer ?? {}) == null
                          ? null
                          : () {
                              Navigator.pop(context, {
                                'user_id': _idOf(selectedOfficer!),
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
                      label: const Text('Tugaskan'),
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

class AdminUnitFieldOfficerSelectionSheet extends StatefulWidget {
  const AdminUnitFieldOfficerSelectionSheet({
    super.key,
    required this.officers,
    this.selectedId,
  });

  final List<Map<String, dynamic>> officers;
  final int? selectedId;

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required List<Map<String, dynamic>> officers,
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
      builder: (_) => AdminUnitFieldOfficerSelectionSheet(
        officers: officers,
        selectedId: selectedId,
      ),
    );
  }

  @override
  State<AdminUnitFieldOfficerSelectionSheet> createState() =>
      _AdminUnitFieldOfficerSelectionSheetState();
}

class _AdminUnitFieldOfficerSelectionSheetState
    extends State<AdminUnitFieldOfficerSelectionSheet> {
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
    return (item['name'] ?? item['nama'] ?? 'Field Officer').toString();
  }

  String _emailOf(Map<String, dynamic> item) {
    return (item['email'] ?? '').toString();
  }

  String _phoneOf(Map<String, dynamic> item) {
    return (item['phone'] ?? '').toString();
  }

  @override
  Widget build(BuildContext context) {
    final filteredOfficers = widget.officers.where((officer) {
      final searchText = [
        _nameOf(officer),
        _emailOf(officer),
        _phoneOf(officer),
      ].join(' ').toLowerCase();

      return searchText.contains(searchQuery);
    }).toList();

    final screenHeight = MediaQuery.of(context).size.height;
    final maxSheetHeight = screenHeight * 0.75;

    return SizedBox(
      width: double.infinity,
      height: maxSheetHeight,
      child: Column(
        children: [
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
                    Icons.groups_outlined,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Field Officer',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Cari petugas berdasarkan nama atau kontak.',
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
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari nama, email, atau nomor HP...',
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Petugas tersedia',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${filteredOfficers.length} petugas',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: widget.officers.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Belum ada Field Officer pada unit ini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                : filteredOfficers.isEmpty
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
                            'Petugas tidak ditemukan.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : RadioGroup<int>(
                    groupValue: selectedId,
                    onChanged: (value) {
                      if (value == null) return;

                      final officer = filteredOfficers.firstWhere(
                        (item) => _idOf(item) == value,
                      );

                      Navigator.pop(context, officer);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      itemCount: filteredOfficers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final officer = filteredOfficers[index];
                        final id = _idOf(officer);

                        if (id == null) {
                          return const SizedBox.shrink();
                        }

                        final selected = selectedId == id;

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
                                vertical: 4,
                              ),
                              secondary: CircleAvatar(
                                backgroundColor: AppColors.blue.withValues(
                                  alpha: 0.10,
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.blue,
                                ),
                              ),
                              title: Text(
                                _nameOf(officer),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_emailOf(officer).isNotEmpty)
                                    Text(
                                      _emailOf(officer),
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  if (_phoneOf(officer).isNotEmpty)
                                    Text(
                                      _phoneOf(officer),
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              16 + MediaQuery.paddingOf(context).bottom,
            ),
            child: SizedBox(
              width: double.infinity,
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
          ),
        ],
      ),
    );
  }
}
