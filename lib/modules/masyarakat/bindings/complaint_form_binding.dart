import 'package:elingk/modules/masyarakat/controllers/complaint_form_controller.dart';
import 'package:get/get.dart';

class ComplaintFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplaintFormController>(() => ComplaintFormController());
  }
}
