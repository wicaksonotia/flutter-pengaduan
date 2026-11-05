import 'package:get/get.dart';

import 'package:sapahub/app/routes/app_routes.dart';

class AdminUnitController extends GetxController {
  void openDashboard() {
    Get.offAllNamed(AppRoutes.adminUnit);
  }

  void openComplaints() {
    Get.toNamed(AppRoutes.adminUnitComplaints);
  }

  void openBerita() {
    Get.toNamed(AppRoutes.adminUnitBerita);
  }

  void openProfile() {
    // Profil menggunakan SharedProfileView dari menu.
  }
}
