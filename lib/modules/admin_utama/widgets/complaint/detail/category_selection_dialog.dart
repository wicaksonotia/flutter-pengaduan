import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategorySelectionDialog extends StatefulWidget {
  const CategorySelectionDialog({
    super.key,
    required this.categories,
    this.selectedId,
  });

  final List<Map<String, dynamic>> categories;
  final int? selectedId;

  static Future<int?> show(
    BuildContext context, {
    required List<Map<String, dynamic>> categories,
    int? selectedId,
  }) {
    return showDialog<int>(
      context: context,
      builder: (_) => CategorySelectionDialog(
        categories: categories,
        selectedId: selectedId,
      ),
      barrierDismissible: false,
    );
  }

  @override
  State<CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  int? selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
  }

  int? _idOf(Map<String, dynamic> item) {
    final value = item['id'];
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  String _nameOf(Map<String, dynamic> item) {
    return (item['nama'] ??
            item['name'] ??
            item['judul'] ??
            item['label'] ??
            'Kategori ${item['id'] ?? ''}')
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'Pilih Kategori',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.categories.isEmpty
            ? const Text(
                'Belum ada kategori yang tersedia.',
                style: TextStyle(color: AppColors.textSecondary),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: widget.categories.length,
                separatorBuilder: (_, _) =>
                    const Divider(color: AppColors.divider, height: 1),
                itemBuilder: (context, index) {
                  final item = widget.categories[index];
                  final id = _idOf(item);

                  if (id == null) return const SizedBox.shrink();

                  return RadioGroup<int>(
                    groupValue: selectedId,
                    onChanged: (value) {
                      setState(() => selectedId = value);
                    },
                    child: RadioListTile<int>(
                      value: id,
                      activeColor: AppColors.blue,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _nameOf(item),
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.textOnPrimary,
          ),
          onPressed: selectedId == null
              ? null
              : () => Navigator.pop(context, selectedId),
          child: const Text('Simpan Kategori'),
        ),
      ],
    );
  }
}
