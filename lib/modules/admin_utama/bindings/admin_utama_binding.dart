import 'package:get/get.dart';

import '../controllers/admin_utama_controller.dart';

class AdminUtamaBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AdminUtamaController>()) {
      Get.lazyPut<AdminUtamaController>(() => AdminUtamaController());
    }
  }
}
