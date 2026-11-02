import 'package:get/get.dart';

import 'package:elingk/app/routes/app_routes.dart';

class AdminUnitController extends GetxController {
  void openDashboard() {
    Get.offAllNamed(AppRoutes.adminUnit);
  }

  void openComplaints() {
    // Akan dihubungkan dengan modul pengaduan Admin Unit.
    Get.snackbar(
      'Pengelolaan Pengaduan',
      'Modul ini akan dikembangkan pada tahap berikutnya.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openBerita() {
    Get.toNamed(AppRoutes.adminUnitBerita);
  }

  void openProfile() {
    // Profil menggunakan SharedProfileView dari menu.
  }
}
