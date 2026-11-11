import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/app/utils/image_url_helper.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_header.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_history.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_information.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_location.dart';
import 'package:sigapkawan/modules/shared/views/complaint/complaint_detail_photos.dart';
import 'package:flutter/material.dart';

import 'complaint_detail_responses.dart';

class ComplaintDetailContent extends StatelessWidget {
  const ComplaintDetailContent({
    super.key,
    required this.data,
    required this.onRefresh,
    required this.mapList,
  });

  final Map<String, dynamic> data;
  final Future<void> Function() onRefresh;
  final List<Map<String, dynamic>> Function(dynamic value) mapList;

  @override
  Widget build(BuildContext context) {
    final photos = mapList(data['photos']);
    final evidencePhotos = mapList(data['evidence_photos']);

    final histories = mapList(
      data['status_histories'] ?? data['statusHistories'],
    );

    final responses = mapList(data['responses']);

    final submittedAt = data['diajukan_pada'] ?? data['created_at'];

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.blue,
      backgroundColor: AppColors.surface,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        children: [
          _buildHeader(submittedAt),

          const SizedBox(height: 18),

          _buildInformation(),

          const SizedBox(height: 15),

          _buildLocation(),

          if (photos.isNotEmpty) ...[
            const SizedBox(height: 15),
            _buildComplaintPhotos(photos),
          ],

          if (evidencePhotos.isNotEmpty) ...[
            const SizedBox(height: 15),
            _buildEvidencePhotos(evidencePhotos),
          ],

          const SizedBox(height: 15),

          _buildHistory(histories),

          if (responses.isNotEmpty) ...[
            const SizedBox(height: 15),
            ComplaintDetailResponses(responses: responses),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic submittedAt) {
    return ComplaintDetailHeader(
      nomorPengaduan: data['nomor_pengaduan'],
      status: data['status'],
      submittedAt: submittedAt,
    );
  }

  Widget _buildInformation() {
    return ComplaintDetailInformation(
      judul: data['judul'],
      isiPengaduan: data['isi_pengaduan'],
      category: data['category'],
      unit: data['unit'],
    );
  }

  Widget _buildLocation() {
    return ComplaintDetailLocation(
      alamat: data['alamat'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  Widget _buildComplaintPhotos(List<Map<String, dynamic>> photos) {
    return ComplaintDetailPhotos(
      photos: photos,
      resolveImageUrl: ImageUrlHelper.resolve,
    );
  }

  Widget _buildEvidencePhotos(List<Map<String, dynamic>> photos) {
    return ComplaintDetailPhotos(
      photos: photos,
      resolveImageUrl: ImageUrlHelper.resolve,
      title: 'Foto Bukti Penanganan',
      icon: Icons.fact_check_outlined,
    );
  }

  Widget _buildHistory(List<Map<String, dynamic>> histories) {
    return ComplaintDetailHistory(histories: histories);
  }
}
