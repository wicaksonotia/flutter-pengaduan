import 'package:elingk/modules/field_officer/bindings/field_officer_assignment_detail_binding.dart';
import 'package:elingk/modules/field_officer/views/complaints/field_officer_assignment_detail_view.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldOfficerAssignmentTile extends StatelessWidget {
  const FieldOfficerAssignmentTile({super.key, required this.assignment});

  final Map<String, dynamic> assignment;

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    final complaint = _asMap(
      assignment['complaint'] ?? assignment['pengaduan'],
    );

    return SharedComplaintCard(
      complaint: complaint,
      showUnit: true,
      onTap: () {
        final assignmentId = int.tryParse(assignment['id']?.toString() ?? '');

        if (assignmentId == null) {
          Get.snackbar(
            'Tidak dapat membuka detail',
            'ID penugasan tidak valid.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        Get.to(
          () => FieldOfficerAssignmentDetailView(assignmentId: assignmentId),
          binding: FieldOfficerAssignmentDetailBinding(
            assignmentId: assignmentId,
          ),
        );
      },
    );
  }
}
