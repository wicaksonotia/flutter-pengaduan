import 'package:sigapkawan/modules/shared/bindings/shared_profile_binding.dart';
import 'package:get/get.dart';

import '../controllers/admin_utama_controller.dart';
import '../controllers/admin_utama_dashboard_controller.dart';

class AdminUtamaBinding extends Bindings {
  @override
  void dependencies() {
    // Shared Profile
    SharedProfileBinding().dependencies();

    if (!Get.isRegistered<AdminUtamaController>()) {
      Get.lazyPut<AdminUtamaController>(() => AdminUtamaController());
    }

    if (!Get.isRegistered<AdminUtamaDashboardController>()) {
      Get.lazyPut<AdminUtamaDashboardController>(
        () => AdminUtamaDashboardController(),
      );
    }
  }
}
