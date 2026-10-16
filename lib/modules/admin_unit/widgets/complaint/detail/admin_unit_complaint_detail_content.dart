import 'package:elingk/app/utils/image_url_helper.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaint_detail_controller.dart';
import 'package:elingk/modules/admin_unit/widgets/complaint/detail/admin_unit_complaint_detail_actions.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_header.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_history.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_information.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_location.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_detail_photos.dart';
import 'package:flutter/material.dart';

class AdminUnitComplaintDetailContent extends StatelessWidget {
  const AdminUnitComplaintDetailContent({
    super.key,
    required this.data,
    required this.controller,
    required this.loadingOfficers,
    required this.onAssignOfficer,
  });

  final Map<String, dynamic> data;
  final AdminUnitComplaintDetailController controller;
  final bool loadingOfficers;
  final VoidCallback onAssignOfficer;

  @override
  Widget build(BuildContext context) {
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

    return ListView(
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
          unit: unit,
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

        if (histories.isNotEmpty) ...[
          const SizedBox(height: 16),
          ComplaintDetailHistory(histories: histories),
        ],

        if (canAssignOfficer) ...[
          const SizedBox(height: 24),
          AdminUnitComplaintDetailActions(
            isLoading: loadingOfficers || controller.assigning.value,
            loadingOfficers: loadingOfficers,
            isAssigning: controller.assigning.value,
            onAssignOfficer: onAssignOfficer,
          ),
        ],

        const SizedBox(height: 20),
      ],
    );
  }
}
