import 'package:get/get.dart';
import 'package:sigapkawan/modules/admin_unit/controllers/admin_unit_berita_controller.dart';

class AdminUnitBeritaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUnitBeritaController>(() => AdminUnitBeritaController());
  }
}
