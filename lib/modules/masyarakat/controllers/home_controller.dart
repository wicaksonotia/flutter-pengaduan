import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void openHome() {
    currentIndex.value = 0;
  }

  void openComplaints() {
    currentIndex.value = 1;
  }

  void openProfile() {
    currentIndex.value = 2;
  }
}
