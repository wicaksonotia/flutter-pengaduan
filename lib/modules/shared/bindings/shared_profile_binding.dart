import 'package:elingk/modules/shared/controllers/shared_profile_controller.dart';
import 'package:get/get.dart';

class SharedProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedProfileController>(() => SharedProfileController());
  }
}
