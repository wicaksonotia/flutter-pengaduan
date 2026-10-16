import 'package:get/get.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_complaints_controller.dart';

class AdminUnitBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AdminUnitComplaintsController>()) {
      Get.put<AdminUnitComplaintsController>(AdminUnitComplaintsController());
    }
  }
}
