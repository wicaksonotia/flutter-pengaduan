import 'package:get/get.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_utama_berita_controller.dart';

class AdminUtamaBeritaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUtamaBeritaController>(() => AdminUtamaBeritaController());
  }
}
