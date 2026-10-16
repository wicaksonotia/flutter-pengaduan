import 'package:get/get.dart';
import 'package:elingk/modules/field_officer/controllers/field_officer_assignments_controller.dart';

class FieldOfficerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FieldOfficerAssignmentsController>(
      () => FieldOfficerAssignmentsController(),
    );
  }
}
