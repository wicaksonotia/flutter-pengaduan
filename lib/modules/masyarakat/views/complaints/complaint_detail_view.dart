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
      appBar: _buildAppBar(),
      body: Obx(() {
        final data = controller.complaint.value;
        final isLoading = controller.loading.value;
        final error = controller.error.value;

        // Loading pertama kali, ketika data belum tersedia.
        if (data == null && isLoading) {
          return _buildLoading();
        }

        // Error ketika data detail belum berhasil dimuat.
        if (data == null && error != null) {
          return SharedComplaintError(
            message: error,
            onRetry: controller.loadDetail,
          );
        }

        // Kondisi ketika data benar-benar tidak tersedia.
        if (data == null) {
          return SharedComplaintError(
            message: 'Data detail pengaduan tidak ditemukan.',
            onRetry: controller.loadDetail,
          );
        }

        return Stack(
          children: [
            ComplaintDetailContent(
              data: Map<String, dynamic>.from(data),
              onRefresh: controller.loadDetail,
              mapList: controller.mapList,
            ),

            if (isLoading)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.blue,
                  backgroundColor: AppColors.surfaceSoft,
                ),
              ),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      elevation: 0,
      title: const Text(
        'Detail Pengaduan',
        style: TextStyle(
          color: AppColors.navy,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.blue),
    );
  }
}
