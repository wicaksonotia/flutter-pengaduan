import 'package:elingk/modules/field_officer/controllers/field_officer_assignments_controller.dart';
import 'package:get/get.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaints_controller.dart';

class FieldOfficerComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FieldOfficerAssignmentsController>(
      () => FieldOfficerAssignmentsController(),
    );
  }
}
