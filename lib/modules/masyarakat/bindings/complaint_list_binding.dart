import 'package:elingk/modules/masyarakat/controllers/complaint_list_controller.dart';
import 'package:get/get.dart';

class ComplaintListBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ComplaintListController>()) {
      Get.lazyPut<ComplaintListController>(() => ComplaintListController());
    }
  }
}
