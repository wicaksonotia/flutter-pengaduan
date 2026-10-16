import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/utils/image_url_helper.dart';
import 'package:elingk/modules/field_officer/controllers/field_officer_assignment_detail_controller.dart';
import 'package:elingk/modules/field_officer/widgets/complaints/assignment_detail/assignment_evidence_photos.dart';
import 'package:elingk/modules/field_officer/widgets/complaints/assignment_detail/assignment_notes_section.dart';
import 'package:elingk/modules/field_officer/widgets/complaints/assignment_detail/assignment_result_section.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_header.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_history.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_information.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_location.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_photos.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_photo_source_button.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FieldOfficerAssignmentDetailView extends StatelessWidget {
  final int assignmentId;

  const FieldOfficerAssignmentDetailView({
    super.key,
    required this.assignmentId,
  });

  @override
  Widget build(BuildContext context) {
    final tag = 'assignment_detail_$assignmentId';

    final controller = Get.find<FieldOfficerAssignmentDetailController>(
      tag: tag,
    );

    return _AssignmentDetailContent(controller: controller);
  }
}

class _AssignmentDetailContent extends StatelessWidget {
  final FieldOfficerAssignmentDetailController controller;

  const _AssignmentDetailContent({required this.controller});

  Future<void> _showPhotoOptions(BuildContext context) async {
    if (controller.isSubmitting.value) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tambah Foto',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pilih sumber foto untuk bukti hasil penanganan.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
                ComplaintPhotoSourceButton(
                  icon: Icons.camera_alt_outlined,
                  title: 'Ambil Foto',
                  subtitle: 'Gunakan kamera perangkat',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    controller.pickPhotos(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 10),
                ComplaintPhotoSourceButton(
                  icon: Icons.photo_library_outlined,
                  title: 'Pilih dari Galeri',
                  subtitle: 'Pilih foto yang sudah tersimpan',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    controller.pickPhotos(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Detail Penugasan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Obx(() {
        final assignment = controller.assignment.value;

        if (controller.isLoading.value && assignment == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.blue),
          );
        }

        if (assignment == null) {
          return SharedComplaintError(
            message:
                controller.error.value ??
                'Data detail penugasan tidak tersedia.',
            onRetry: controller.loadDetail,
          );
        }

        final complaint = controller.complaint;
        final photos = controller.extractPhotos(complaint['photos']);
        final evidencePhotos = _mapList(assignment['evidence_photos']);
        final responses = _mapList(complaint['responses']);

        final notes = responses.where((response) {
          return response['untuk_publik'] == false ||
              response['untuk_publik'] == 0;
        }).toList();

        final histories = _mapList(
          complaint['status_histories'] ?? complaint['statusHistories'],
        );

        final submittedAt =
            complaint['diajukan_pada'] ?? complaint['created_at'];

        return Stack(
          children: [
            RefreshIndicator(
              color: AppColors.blue,
              onRefresh: controller.loadDetail,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  ComplaintDetailHeader(
                    nomorPengaduan: complaint['nomor_pengaduan'],
                    status: complaint['status'],
                    submittedAt: submittedAt,
                  ),
                  const SizedBox(height: 16),

                  ComplaintDetailInformation(
                    judul: complaint['judul'],
                    isiPengaduan: complaint['isi_pengaduan'],
                    category: complaint['category'],
                    unit: complaint['unit'],
                  ),
                  const SizedBox(height: 16),

                  ComplaintDetailLocation(
                    alamat: complaint['alamat'],
                    latitude: complaint['latitude'],
                    longitude: complaint['longitude'],
                  ),

                  if (photos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ComplaintDetailPhotos(
                      photos: photos,
                      resolveImageUrl: ImageUrlHelper.resolve,
                    ),
                  ],

                  if (notes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    AssignmentNotesSection(notes: notes),
                  ],

                  if (evidencePhotos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    AssignmentEvidencePhotos(photos: evidencePhotos),
                  ],

                  if (histories.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ComplaintDetailHistory(histories: histories),
                  ],

                  const SizedBox(height: 16),

                  AssignmentResultSection(
                    canSubmit: controller.canSubmit,
                    selesaiPada: assignment['selesai_pada'],
                    value: controller.value,
                    catatanController: controller.catatanController,
                    photos: controller.photos.toList(),
                    submitting: controller.isSubmitting.value,
                    onAddPhoto: () => _showPhotoOptions(context),
                    onRemovePhoto: controller.removePhoto,
                    onSubmit: controller.submitResult,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            if (controller.isLoading.value)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.blue,
                  backgroundColor: AppColors.surfaceMuted,
                ),
              ),
          ],
        );
      }),
    );
  }
}
