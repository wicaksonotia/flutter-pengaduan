import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_complaint_detail_controller.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_header.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_history.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_information.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_location.dart';
import 'package:elingk/modules/masyarakat/views/complaints/widgets/detail/complaint_detail_photos.dart';
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
        if (controller.loading.value && controller.complaint.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null &&
            controller.complaint.value == null) {
          return _errorView(controller.error.value!);
        }

        final data = controller.complaint.value;

        if (data == null) {
          return _errorView('Data detail pengaduan tidak tersedia.');
        }

        final photos = controller.mapList(data['photos']);

        final histories = controller.mapList(
          data['status_histories'] ?? data['statusHistories'],
        );

        final submittedAt = data['diajukan_pada'] ?? data['created_at'];

        return Stack(
          children: [
            RefreshIndicator(
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
                    ComplaintDetailPhotos(
                      photos: photos,
                      resolveImageUrl: controller.imageUrl,
                    ),
                  ],

                  const SizedBox(height: 16),
                  ComplaintDetailHistory(histories: histories),

                  const SizedBox(height: 20),

                  // Komponen tindakan admin akan ditempatkan di sini.
                  // Kategori, delegasi unit, dan penolakan akan
                  // dihubungkan ke endpoint backend berikutnya.
                ],
              ),
            ),

            if (controller.loading.value && controller.complaint.value != null)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(minHeight: 2),
              ),
          ],
        );
      }),
    );
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
            ),
          ],
        ),
      ),
    );
  }
}
