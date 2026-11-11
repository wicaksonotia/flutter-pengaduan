import 'package:get/get.dart';
import 'package:sigapkawan/app/routes/app_routes.dart';

class AdminUtamaController extends GetxController {
  void openDashboard() {
    Get.offAllNamed(AppRoutes.adminUtama);
  }

  void openComplaints() {
    Get.toNamed(AppRoutes.adminUtamaComplaints);
  }

  void openBerita() {
    Get.toNamed(AppRoutes.adminUtamaBerita);
  }

  void openProfile() {
    // Profil menggunakan SharedProfileView dari menu.
  }
}
