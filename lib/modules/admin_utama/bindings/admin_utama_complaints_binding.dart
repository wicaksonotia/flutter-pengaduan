import 'package:sigapkawan/modules/admin_utama/controllers/admin_complaints_controller.dart';
import 'package:get/get.dart';

class AdminUtamaComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminComplaintsController>(() => AdminComplaintsController());
  }
}
