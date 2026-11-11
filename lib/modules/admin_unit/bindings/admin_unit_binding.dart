import 'package:sigapkawan/modules/admin_unit/controllers/admin_unit_controller.dart';
import 'package:sigapkawan/modules/admin_unit/controllers/admin_unit_dashboard_controller.dart';
import 'package:sigapkawan/modules/shared/bindings/shared_profile_binding.dart';
import 'package:get/get.dart';

class AdminUnitBinding extends Bindings {
  @override
  void dependencies() {
    // Shared Profile
    SharedProfileBinding().dependencies();

    if (!Get.isRegistered<AdminUnitController>()) {
      Get.lazyPut<AdminUnitController>(() => AdminUnitController());
    }

    if (!Get.isRegistered<AdminUnitDashboardController>()) {
      Get.lazyPut<AdminUnitDashboardController>(
        () => AdminUnitDashboardController(),
      );
    }
  }
}
