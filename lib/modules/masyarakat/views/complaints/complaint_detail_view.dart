import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/bindings/complaint_detail_binding.dart';
import 'package:elingk/modules/masyarakat/controllers/complaint_detail_controller.dart';
import 'package:elingk/modules/masyarakat/widgets/detail/complaint_detail_content.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintDetailView extends StatefulWidget {
  const ComplaintDetailView({super.key, required this.complaintId});

  final int complaintId;

  @override
  State<ComplaintDetailView> createState() => _ComplaintDetailViewState();
}

class _ComplaintDetailViewState extends State<ComplaintDetailView> {
  late final ComplaintDetailController controller;
  late final String controllerTag;

  @override
  void initState() {
    super.initState();

    final binding = ComplaintDetailBinding(complaintId: widget.complaintId);

    controllerTag = binding.tag;
    binding.dependencies();

    controller = Get.find<ComplaintDetailController>(tag: controllerTag);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ComplaintDetailController>(tag: controllerTag)) {
      Get.delete<ComplaintDetailController>(tag: controllerTag, force: true);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Pengaduan',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.blue),
          );
        }

        final error = controller.error.value;

        if (error != null) {
          return SharedComplaintError(
            message: error,
            onRetry: controller.loadDetail,
          );
        }

        final data = controller.complaint.value;

        if (data == null) {
          return SharedComplaintError(
            message: 'Data detail pengaduan tidak ditemukan.',
            onRetry: controller.loadDetail,
          );
        }

        return ComplaintDetailContent(
          data: Map<String, dynamic>.from(data),
          onRefresh: controller.loadDetail,
          mapList: controller.mapList,
        );
      }),
    );
  }
}
