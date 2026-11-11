import 'package:get/get.dart';
import 'package:sigapkawan/modules/admin_utama/controllers/admin_utama_units_controller.dart';

class AdminUtamaUnitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUtamaUnitsController>(() => AdminUtamaUnitsController());
  }
}
