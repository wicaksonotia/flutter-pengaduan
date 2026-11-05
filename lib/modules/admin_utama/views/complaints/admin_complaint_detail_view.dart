import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/admin_utama/controllers/admin_complaint_detail_controller.dart';
import 'package:sapahub/modules/admin_utama/widgets/complaint/detail/admin_complaint_detail_content.dart';
import 'package:sapahub/modules/shared/widgets/complaint/shared_complaint_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminComplaintDetailView extends StatefulWidget {
  const AdminComplaintDetailView({super.key, required this.complaintId});

  final int complaintId;

  @override
  State<AdminComplaintDetailView> createState() =>
      _AdminComplaintDetailViewState();
}

class _AdminComplaintDetailViewState extends State<AdminComplaintDetailView> {
  late final String controllerTag;
  late final AdminComplaintDetailController controller;

  @override
  void initState() {
    super.initState();

    controllerTag = 'admin_complaint_detail_${widget.complaintId}';

    controller = Get.put(
      AdminComplaintDetailController(complaintId: widget.complaintId),
      tag: controllerTag,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<AdminComplaintDetailController>(tag: controllerTag)) {
      Get.delete<AdminComplaintDetailController>(tag: controllerTag);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Pengaduan'),
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
              child: AdminComplaintDetailContent(
                data: data,
                controller: controller,
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

            if (controller.actionLoading.value)
              const Positioned.fill(
                child: ColoredBox(
                  color: AppColors.shadow,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.blue),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
