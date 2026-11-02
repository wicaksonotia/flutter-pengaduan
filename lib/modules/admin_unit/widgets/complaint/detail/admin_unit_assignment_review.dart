import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaint_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitAssignmentReview extends StatelessWidget {
  const AdminUnitAssignmentReview({super.key, required this.controller});

  final AdminUnitComplaintDetailController controller;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Obx(() {
      final isLoading = controller.reviewing.value;

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pemeriksaan Hasil Penanganan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 5),

            const Text(
              'Periksa catatan dan foto bukti sebelum memberikan keputusan.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading ? null : () => _confirmApproval(context),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Setujui Hasil Penanganan'),
              ),
            ),

            const SizedBox(height: 9),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () => _requestImprovement(context),
                icon: const Icon(Icons.edit_note),
                label: const Text('Perlu Perbaikan'),
              ),
            ),

            if (isLoading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'Sedang menyimpan keputusan...',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Future<void> _confirmApproval(BuildContext context) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Setujui Hasil Penanganan?'),
        content: const Text(
          'Hasil pekerjaan Field Officer akan diteruskan '
          'ke Admin Utama untuk verifikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Ya, Setujui'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await controller.reviewAssignment(keputusan: 'disetujui');

    _showResult(
      success: success,
      successMessage:
          'Hasil penanganan disetujui dan diteruskan ke Admin Utama.',
      errorMessage: 'Gagal menyetujui hasil penanganan.',
    );
  }

  Future<void> _requestImprovement(BuildContext context) async {
    final noteController = TextEditingController();

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Perlu Perbaikan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tuliskan bagian yang harus diperbaiki oleh Field Officer.',
              style: TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: noteController,
              maxLines: 4,
              maxLength: 5000,
              decoration: const InputDecoration(
                hintText: 'Contoh: Foto bukti belum memperlihatkan hasil...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (noteController.text.trim().isEmpty) {
                Get.snackbar(
                  'Catatan wajib diisi',
                  'Tuliskan alasan atau instruksi perbaikan.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              Get.back(result: true);
            },
            child: const Text('Kirim Perbaikan'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      noteController.dispose();
      return;
    }

    final note = noteController.text.trim();
    noteController.dispose();

    final success = await controller.reviewAssignment(
      keputusan: 'perlu_perbaikan',
      catatan: note,
    );

    _showResult(
      success: success,
      successMessage:
          'Pengaduan dikembalikan kepada Field Officer untuk diperbaiki.',
      errorMessage: 'Gagal mengirim permintaan perbaikan.',
    );
  }

  void _showResult({
    required bool success,
    required String successMessage,
    required String errorMessage,
  }) {
    Get.snackbar(
      success ? 'Berhasil' : 'Gagal',
      success ? successMessage : controller.actionError.value ?? errorMessage,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
