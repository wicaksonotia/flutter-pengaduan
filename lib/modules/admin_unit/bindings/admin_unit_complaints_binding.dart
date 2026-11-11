import 'package:get/get.dart';
import 'package:sigapkawan/modules/admin_unit/controllers/admin_unit_complaints_controller.dart';

class AdminUnitComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUnitComplaintsController>(
      () => AdminUnitComplaintsController(),
    );
  }
}
