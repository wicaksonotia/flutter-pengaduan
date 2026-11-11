import 'package:sigapkawan/modules/masyarakat/bindings/news_binding.dart';
import 'package:sigapkawan/modules/masyarakat/controllers/home_controller.dart';
import 'package:sigapkawan/modules/masyarakat/controllers/masyarakat_dashboard_controller.dart';
import 'package:sigapkawan/modules/shared/bindings/shared_profile_binding.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Shared Profile
    SharedProfileBinding().dependencies();

    // News
    NewsBinding().dependencies();

    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }

    if (!Get.isRegistered<MasyarakatDashboardController>()) {
      Get.lazyPut<MasyarakatDashboardController>(
        () => MasyarakatDashboardController(),
      );
    }
  }
}
