import 'package:sapahub/modules/field_officer/controllers/field_officer_assignments_controller.dart';
import 'package:sapahub/modules/field_officer/controllers/field_officer_dashboard_controller.dart';
import 'package:sapahub/modules/shared/bindings/shared_profile_binding.dart';
import 'package:get/get.dart';

class FieldOfficerBinding extends Bindings {
  @override
  void dependencies() {
    // Shared Profile
    SharedProfileBinding().dependencies();

    if (!Get.isRegistered<FieldOfficerAssignmentsController>()) {
      Get.lazyPut<FieldOfficerAssignmentsController>(
        () => FieldOfficerAssignmentsController(),
      );
    }

    if (!Get.isRegistered<FieldOfficerDashboardController>()) {
      Get.lazyPut<FieldOfficerDashboardController>(
        () => FieldOfficerDashboardController(),
      );
    }
  }
}
