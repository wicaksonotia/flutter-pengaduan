import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ComplaintRejectionDialog extends StatefulWidget {
  const ComplaintRejectionDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ComplaintRejectionDialog(),
    );
  }

  @override
  State<ComplaintRejectionDialog> createState() =>
      _ComplaintRejectionDialogState();
}

class _ComplaintRejectionDialogState extends State<ComplaintRejectionDialog> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'Tolak Pengaduan',
        style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
      ),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tuliskan alasan penolakan yang jelas agar dapat menjadi catatan pemeriksaan.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                autofocus: true,
                minLines: 3,
                maxLines: 5,
                maxLength: 2000,
                decoration: InputDecoration(
                  hintText: 'Masukkan alasan penolakan...',
                  filled: true,
                  fillColor: AppColors.surfaceSoft,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alasan penolakan wajib diisi.';
                  }

                  if (value.trim().length < 5) {
                    return 'Alasan minimal 5 karakter.';
                  }

                  return null;
                },
              ),
            ],
          ),
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
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.danger,
            foregroundColor: AppColors.textOnPrimary,
          ),
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            Navigator.pop(context, controller.text.trim());
          },
          icon: const Icon(Icons.block_outlined),
          label: const Text('Lanjutkan'),
        ),
      ],
    );
  }
}
