import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/utils/image_url_helper.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaint_detail_controller.dart';
import 'package:elingk/modules/admin_unit/widgets/complaint/admin_unit_field_officer_assignment_sheet.dart';
import 'package:elingk/modules/admin_utama/widgets/complaint/detail/admin_complaint_detail_photos.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_header.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_history.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_information.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitComplaintDetailView extends StatefulWidget {
  const AdminUnitComplaintDetailView({super.key, required this.complaintId});

  final int complaintId;

  @override
  State<AdminUnitComplaintDetailView> createState() =>
      _AdminUnitComplaintDetailViewState();
}

class _AdminUnitComplaintDetailViewState
    extends State<AdminUnitComplaintDetailView> {
  late final String controllerTag;
  late final AdminUnitComplaintDetailController controller;

  bool _loadingOfficers = false;
  @override
  void initState() {
    super.initState();

    controllerTag = 'admin_unit_complaint_detail_${widget.complaintId}';

    controller = Get.put(
      AdminUnitComplaintDetailController(complaintId: widget.complaintId),
      tag: controllerTag,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<AdminUnitComplaintDetailController>(
      tag: controllerTag,
    )) {
      Get.delete<AdminUnitComplaintDetailController>(tag: controllerTag);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Detail Pengaduan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Obx(() {
        final data = controller.complaint.value;

        if (controller.loading.value && data == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.blue),
          );
        }

        if (data == null) {
          return _errorView(
            controller.error.value ?? 'Data detail pengaduan tidak tersedia.',
          );
        }

        final photos = controller.mapList(data['photos']);
        final histories = controller.mapList(
          data['status_histories'] ?? data['statusHistories'],
        );

        final submittedAt = data['diajukan_pada'] ?? data['created_at'];

        final unit = data['unit'];
        final unitId = unit is Map ? int.tryParse('${unit['id']}') : null;

        final status = '${data['status'] ?? ''}'.toLowerCase();

        final assignments = controller.mapList(data['assignments']);

        final hasActiveAssignment = assignments.any(
          (assignment) => assignment['selesai_pada'] == null,
        );

        final canAssignOfficer =
            unitId != null &&
            (status == 'ditugaskan' || status == 'diproses') &&
            !hasActiveAssignment;

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
                    nomorPengaduan: data['nomor_pengaduan'],
                    status: data['status'],
                    submittedAt: submittedAt,
                  ),
                  const SizedBox(height: 16),

                  ComplaintDetailInformation(
                    judul: data['judul'],
                    isiPengaduan: data['isi_pengaduan'],
                    category: data['category'],
                    unit: data['unit'],
                  ),
                  const SizedBox(height: 16),

                  ComplaintDetailLocation(
                    alamat: data['alamat'],
                    latitude: data['latitude'],
                    longitude: data['longitude'],
                  ),

                  if (photos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    AdminComplaintDetailPhotos(
                      photos: photos,
                      resolveImageUrl: ImageUrlHelper.resolve,
                    ),
                  ],

                  if (histories.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ComplaintDetailHistory(histories: histories),
                  ],

                  if (canAssignOfficer) ...[
                    const SizedBox(height: 24),
                    _assignOfficerButton(unitId),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),

            if (controller.loading.value)
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

  Widget _assignOfficerButton(int unitId) {
    final isLoading = _loadingOfficers || controller.assigning.value;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isLoading ? null : () => _openFieldOfficerAssignment(unitId),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.textOnPrimary,
                ),
              )
            : const Icon(Icons.assignment_ind_outlined),
        label: Text(
          _loadingOfficers
              ? 'Memuat daftar petugas...'
              : controller.assigning.value
              ? 'Meneruskan pengaduan...'
              : 'Teruskan ke Field Officer',
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.75),
          disabledForegroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _openFieldOfficerAssignment(int unitId) async {
    if (_loadingOfficers || controller.assigning.value) return;

    setState(() => _loadingOfficers = true);

    try {
      await controller.loadFieldOfficers(unitId: unitId);

      if (!mounted) return;

      if (controller.officersError.value != null) {
        Get.snackbar(
          'Gagal mengambil petugas',
          controller.officersError.value!,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (controller.fieldOfficers.isEmpty) {
        Get.snackbar(
          'Petugas tidak tersedia',
          'Belum ada Field Officer yang terdaftar pada unit ini.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final result = await AdminUnitFieldOfficerAssignmentSheet.show(
        context,
        officers: controller.fieldOfficers.toList(),
      );

      if (!mounted || result == null) return;

      final userId = int.tryParse('${result['user_id']}');

      if (userId == null) {
        Get.snackbar(
          'Penugasan gagal',
          'ID Field Officer tidak valid.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final success = await controller.assignFieldOfficer(
        userId: userId,
        catatan: result['catatan']?.toString(),
      );

      if (!mounted) return;

      if (success) {
        Get.snackbar(
          'Berhasil',
          'Pengaduan berhasil diteruskan ke Field Officer.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Penugasan gagal',
          controller.actionError.value ??
              controller.error.value ??
              'Gagal menugaskan Field Officer.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingOfficers = false);
      }
    }
  }

  Widget _errorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textBody, height: 1.5),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: controller.loadDetail,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
