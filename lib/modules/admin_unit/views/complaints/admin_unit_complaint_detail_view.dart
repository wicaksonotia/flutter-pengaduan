import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaint_detail_controller.dart';
import 'package:elingk/modules/admin_unit/widgets/complaint/admin_unit_field_officer_assignment_sheet.dart';
import 'package:elingk/modules/admin_unit/widgets/complaint/detail/admin_unit_complaint_detail_content.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_error.dart';
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
          return SharedComplaintError(
            message:
                controller.error.value ??
                'Data detail pengaduan tidak tersedia.',
            onRetry: controller.loadDetail,
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              color: AppColors.blue,
              onRefresh: controller.loadDetail,
              child: AdminUnitComplaintDetailContent(
                data: Map<String, dynamic>.from(data),
                controller: controller,
                loadingOfficers: _loadingOfficers,
                onAssignOfficer: () {
                  final unit = data['unit'];
                  final unitId = unit is Map
                      ? int.tryParse('${unit['id']}')
                      : null;

                  if (unitId != null) {
                    _openFieldOfficerAssignment(unitId);
                  }
                },
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

  Future<void> _openFieldOfficerAssignment(int unitId) async {
    if (_loadingOfficers || controller.assigning.value) return;

    setState(() => _loadingOfficers = true);

    try {
      await controller.loadFieldOfficers(unitId: unitId);

      if (!mounted) return;

      if (controller.officersError.value != null) {
        _showMessage(
          'Gagal mengambil petugas',
          controller.officersError.value!,
        );
        return;
      }

      if (controller.fieldOfficers.isEmpty) {
        _showMessage(
          'Petugas tidak tersedia',
          'Belum ada Field Officer yang terdaftar pada unit ini.',
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
        _showMessage('Penugasan gagal', 'ID Field Officer tidak valid.');
        return;
      }

      final success = await controller.assignFieldOfficer(
        userId: userId,
        catatan: result['catatan']?.toString(),
      );

      if (!mounted) return;

      if (success) {
        _showMessage(
          'Berhasil',
          'Pengaduan berhasil diteruskan ke Field Officer.',
        );
      } else {
        _showMessage(
          'Penugasan gagal',
          controller.actionError.value ??
              controller.error.value ??
              'Gagal menugaskan Field Officer.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingOfficers = false);
      }
    }
  }

  void _showMessage(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }
}
