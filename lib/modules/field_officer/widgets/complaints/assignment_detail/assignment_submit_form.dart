import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/widgets/app_confirm_dialog.dart';
import 'package:elingk/modules/field_officer/widgets/complaints/assignment_detail/assignment_result_photo_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AssignmentSubmitForm extends StatelessWidget {
  const AssignmentSubmitForm({
    super.key,
    required this.canSubmit,
    required this.catatanController,
    required this.photos,
    required this.submitting,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    required this.onSubmit,
    this.isCompleted = false,
  });

  final bool canSubmit;
  final TextEditingController catatanController;
  final List<XFile> photos;
  final bool submitting;
  final VoidCallback onAddPhoto;
  final ValueChanged<int> onRemovePhoto;
  final VoidCallback onSubmit;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catatan Penanganan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),

        TextField(
          controller: catatanController,
          enabled: canSubmit && !submitting,
          minLines: 4,
          maxLines: 7,
          maxLength: 3000,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Jelaskan tindakan yang sudah dilakukan, kondisi terkini, dan hasil penanganan...',
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              height: 1.5,
            ),
            filled: true,
            fillColor: AppColors.background,
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),

        const SizedBox(height: 20),

        AssignmentResultPhotoSection(
          photos: photos,
          onAddPhoto: onAddPhoto,
          onRemovePhoto: onRemovePhoto,
          enabled: canSubmit && !submitting,
        ),

        const SizedBox(height: 20),

        ValueListenableBuilder<TextEditingValue>(
          valueListenable: catatanController,
          builder: (context, catatan, _) {
            final isEnabled =
                canSubmit &&
                !isCompleted &&
                catatan.text.trim().isNotEmpty &&
                photos.isNotEmpty &&
                !submitting;

            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: !isEnabled
                    ? null
                    : () async {
                        final confirmed = await AppConfirmDialog.show(
                          context,
                          title: 'Kirim Hasil Penanganan?',
                          message:
                              'Setelah dikirim, tugas akan menunggu '
                              'pemeriksaan Admin Unit. Pastikan catatan '
                              'dan foto bukti sudah benar.',
                          confirmText: 'Ya, Kirim',
                          cancelText: 'Periksa Lagi',
                          icon: Icons.fact_check_outlined,
                        );

                        if (confirmed == true && context.mounted) {
                          onSubmit();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: AppColors.surfaceMuted,
                  disabledForegroundColor: AppColors.textMuted,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: submitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 19,
                            height: 19,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.blue,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Mengirim Hasil...',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle_outline_rounded
                                : Icons.send_rounded,
                            size: 18,
                          ),
                          const SizedBox(width: 9),
                          Text(
                            isCompleted
                                ? 'Hasil Sudah Dikirim'
                                : 'Kirim Hasil Penanganan',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
