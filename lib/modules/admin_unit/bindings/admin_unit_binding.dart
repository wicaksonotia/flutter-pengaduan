import 'package:elingk/modules/admin_unit/controllers/admin_unit_controller.dart';
import 'package:elingk/modules/admin_unit/controllers/admin_unit_dashboard_controller.dart';
import 'package:get/get.dart';

class AdminUnitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUnitController>(() => AdminUnitController());

    Get.lazyPut<AdminUnitDashboardController>(
      () => AdminUnitDashboardController(),
    );
  }
}
