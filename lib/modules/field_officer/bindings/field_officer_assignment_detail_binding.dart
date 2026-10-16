import 'package:get/get.dart';

import '../controllers/field_officer_assignment_detail_controller.dart';

class FieldOfficerAssignmentDetailBinding extends Bindings {
  final int assignmentId;

  FieldOfficerAssignmentDetailBinding({required this.assignmentId});

  String get tag => 'assignment_detail_$assignmentId';

  @override
  void dependencies() {
    if (!Get.isRegistered<FieldOfficerAssignmentDetailController>(tag: tag)) {
      Get.lazyPut<FieldOfficerAssignmentDetailController>(
        () =>
            FieldOfficerAssignmentDetailController(assignmentId: assignmentId),
        tag: tag,
      );
    }
  }
}
