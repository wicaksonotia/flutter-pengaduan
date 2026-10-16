import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/field_officer/widgets/complaints/assignment_detail/assignment_submit_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AssignmentResultSection extends StatelessWidget {
  const AssignmentResultSection({
    super.key,
    required this.canSubmit,
    required this.selesaiPada,
    required this.value,
    required this.catatanController,
    required this.photos,
    required this.submitting,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    required this.onSubmit,
  });

  final bool canSubmit;
  final dynamic selesaiPada;
  final dynamic value;
  final TextEditingController catatanController;
  final List<XFile> photos;
  final bool submitting;
  final VoidCallback onAddPhoto;
  final ValueChanged<int> onRemovePhoto;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isCompleted = selesaiPada != null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.blueLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: AppColors.blue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Penanganan',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Lengkapi catatan dan bukti hasil pekerjaan.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (isCompleted) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.blueLight.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.blueLight),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.blue,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Hasil penanganan telah dikirim. '
                      'Penugasan ini tidak dapat dikirim ulang.',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          AssignmentSubmitForm(
            canSubmit: canSubmit && !isCompleted,
            catatanController: catatanController,
            photos: photos,
            submitting: submitting,
            onAddPhoto: onAddPhoto,
            onRemovePhoto: onRemovePhoto,
            onSubmit: onSubmit,
            isCompleted: isCompleted,
          ),

          if (!canSubmit && !isCompleted) ...[
            const SizedBox(height: 10),
            const Text(
              'Penugasan ini belum dapat dikirim. '
              'Periksa status penugasan terlebih dahulu.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
