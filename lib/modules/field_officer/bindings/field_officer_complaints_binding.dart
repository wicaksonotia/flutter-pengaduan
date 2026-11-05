import 'package:sapahub/modules/field_officer/controllers/field_officer_assignments_controller.dart';
import 'package:get/get.dart';

class FieldOfficerComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FieldOfficerAssignmentsController>(
      () => FieldOfficerAssignmentsController(),
    );
  }
}
