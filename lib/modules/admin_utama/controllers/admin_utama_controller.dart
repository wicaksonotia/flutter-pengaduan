import 'package:get/get.dart';

class AdminUtamaController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Statistik akan diisi dari API Laravel pada tahap berikutnya.
  final totalPengaduan = 0.obs;
  final pengaduanBaru = 0.obs;
  final pengaduanDiproses = 0.obs;
  final menungguPersetujuan = 0.obs;

  void openDashboard() {}
  void openComplaints() {}
  void openOrganization() {}
  void openUsers() {}
  void openProfile() {}
}
