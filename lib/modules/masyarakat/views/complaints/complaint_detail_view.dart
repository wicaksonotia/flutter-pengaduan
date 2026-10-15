import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/utils/image_url_helper.dart';
import 'package:elingk/modules/masyarakat/bindings/complaint_detail_binding.dart';
import 'package:elingk/modules/masyarakat/controllers/complaint_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/detail/complaint_detail_header.dart';
import 'widgets/detail/complaint_detail_history.dart';
import 'widgets/detail/complaint_detail_information.dart';
import 'widgets/detail/complaint_detail_location.dart';
import 'widgets/detail/complaint_detail_photos.dart';
import 'widgets/detail/complaint_detail_responses.dart';

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
          return _buildError(error);
        }

        final data = controller.complaint.value;

        if (data == null) {
          return _buildError('Data detail pengaduan tidak ditemukan.');
        }

        return _buildContent(data);
      }),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: AppColors.textMuted,
              size: 58,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: controller.loadDetail,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final photos = controller.mapList(data['photos']);

    final histories = controller.mapList(
      data['status_histories'] ?? data['statusHistories'],
    );

    final responses = controller.mapList(data['responses']);

    final submittedAt = data['diajukan_pada'] ?? data['created_at'];

    return RefreshIndicator(
      onRefresh: controller.loadDetail,
      color: AppColors.blue,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        children: [
          ComplaintDetailHeader(
            nomorPengaduan: data['nomor_pengaduan'],
            status: data['status'],
            submittedAt: submittedAt,
          ),
          const SizedBox(height: 18),
          ComplaintDetailInformation(
            judul: data['judul'],
            isiPengaduan: data['isi_pengaduan'],
            category: data['category'],
            unit: data['unit'],
          ),
          const SizedBox(height: 15),
          ComplaintDetailLocation(
            alamat: data['alamat'],
            latitude: data['latitude'],
            longitude: data['longitude'],
          ),
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 15),
            ComplaintDetailPhotos(
              photos: photos,
              resolveImageUrl: ImageUrlHelper.resolve,
            ),
          ],
          const SizedBox(height: 15),
          ComplaintDetailHistory(histories: histories),
          if (responses.isNotEmpty) ...[
            const SizedBox(height: 15),
            ComplaintDetailResponses(responses: responses),
          ],
        ],
      ),
    );
  }
}
