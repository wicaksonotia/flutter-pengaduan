import 'package:get/get.dart';
import 'package:elingk/modules/masyarakat/controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
  }
}
