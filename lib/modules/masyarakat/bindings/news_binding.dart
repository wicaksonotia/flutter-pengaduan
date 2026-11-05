import 'package:get/get.dart';
import 'package:sapahub/modules/masyarakat/controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
  }
}
