import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/utils/image_url_helper.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_header.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_history.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_information.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_location.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_photos.dart';
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

          if (evidencePhotos.isNotEmpty) ...[
            const SizedBox(height: 15),
            ComplaintDetailPhotos(
              photos: evidencePhotos,
              resolveImageUrl: ImageUrlHelper.resolve,
              title: 'Foto Bukti Penanganan',
              icon: Icons.fact_check_outlined,
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
