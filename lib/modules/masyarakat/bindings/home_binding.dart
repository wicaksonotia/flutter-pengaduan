import 'package:elingk/modules/masyarakat/controllers/home_controller.dart';
import 'package:elingk/modules/masyarakat/controllers/news_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }

    if (!Get.isRegistered<NewsController>()) {
      Get.lazyPut<NewsController>(() => NewsController());
    }
  }
}
