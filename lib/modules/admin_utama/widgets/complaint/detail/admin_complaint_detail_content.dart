import 'package:sigapkawan/app/utils/image_url_helper.dart';
import 'package:sigapkawan/modules/admin_utama/controllers/admin_complaint_detail_controller.dart';
import 'package:sigapkawan/modules/admin_utama/widgets/complaint/detail/admin_complaint_assignment_history.dart';
import 'package:sigapkawan/modules/admin_utama/widgets/complaint/detail/admin_complaint_detail_actions.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_header.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_history.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_information.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_location.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_photos.dart';
import 'package:flutter/material.dart';

class AdminComplaintDetailContent extends StatelessWidget {
  const AdminComplaintDetailContent({
    super.key,
    required this.data,
    required this.controller,
  });

  final Map<String, dynamic> data;
  final AdminComplaintDetailController controller;

  @override
  Widget build(BuildContext context) {
    final photos = controller.mapList(data['photos']);

    final histories = controller.mapList(
      data['status_histories'] ?? data['statusHistories'],
    );

    final assignments = controller.mapList(data['assignments']);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        ComplaintDetailHeader(
          nomorPengaduan: data['nomor_pengaduan'],
          status: data['status'],
          submittedAt: data['diajukan_pada'] ?? data['created_at'],
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
            resolveImageUrl: ImageUrlHelper.resolve,
          ),
        ],

        // RIWAYAT PERUBAHAN STATUS
        if (histories.isNotEmpty) ...[
          const SizedBox(height: 24),
          ComplaintDetailHistory(histories: histories),
        ],

        // RIWAYAT PENUGASAN DAN HASIL PEKERJAAN
        if (assignments.isNotEmpty) ...[
          const SizedBox(height: 24),
          AdminComplaintAssignmentHistory(assignments: assignments),
        ],

        // VERIFIKASI ADMIN UTAMA
        const SizedBox(height: 24),
        AdminComplaintDetailActions(controller: controller),

        const SizedBox(height: 16),
      ],
    );
  }
}
