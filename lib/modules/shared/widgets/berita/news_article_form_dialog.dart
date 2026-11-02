import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsArticleFormDialog extends StatefulWidget {
  final BeritaPengumumanModel? article;

  const NewsArticleFormDialog({super.key, this.article});

  @override
  State<NewsArticleFormDialog> createState() => _NewsArticleFormDialogState();
}

class _NewsArticleFormDialogState extends State<NewsArticleFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judulController;
  late final TextEditingController _ringkasanController;
  late final TextEditingController _kontenController;

  late String _jenis;

  bool get isEdit => widget.article != null;

  @override
  void initState() {
    super.initState();

    final article = widget.article;

    _judulController = TextEditingController(text: article?.judul ?? '');

    _ringkasanController = TextEditingController(
      text: article?.ringkasan ?? '',
    );

    _kontenController = TextEditingController(text: article?.konten ?? '');

    _jenis = article?.jenis ?? 'berita';
  }

  @override
  void dispose() {
    _judulController.dispose();
    _ringkasanController.dispose();
    _kontenController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Get.back(
      result: <String, dynamic>{
        'jenis': _jenis,
        'judul': _judulController.text.trim(),
        'ringkasan': _ringkasanController.text.trim(),
        'konten': _kontenController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? 'Edit Berita' : 'Tambah Berita',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel('Kategori'),
                DropdownButtonFormField<String>(
                  initialValue: _jenis,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'berita', child: Text('Berita')),
                    DropdownMenuItem(
                      value: 'pengumuman',
                      child: Text('Pengumuman'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _jenis = value);
                    }
                  },
                ),

                const SizedBox(height: 16),

                _buildLabel('Judul'),
                TextFormField(
                  controller: _judulController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan judul berita',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildLabel('Ringkasan'),
                TextFormField(
                  controller: _ringkasanController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Ringkasan singkat berita',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                _buildLabel('Konten'),
                TextFormField(
                  controller: _kontenController,
                  minLines: 5,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan isi berita atau pengumuman',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Konten wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(isEdit ? 'Simpan' : 'Tambah'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
