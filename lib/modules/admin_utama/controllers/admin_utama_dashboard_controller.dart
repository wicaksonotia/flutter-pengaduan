import 'package:get/get.dart';
import 'package:elingk/modules/admin_utama/services/admin_utama_service.dart';

class AdminUtamaDashboardController extends GetxController {
  final AdminUtamaService _service = AdminUtamaService();

  // Loading
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Statistik
  final statistics = <String, dynamic>{}.obs;

  // Pengaduan terbaru
  final recentComplaints = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getDashboard();

      // Statistik dari backend
      final statisticData = result['statistics'];

      if (statisticData is Map) {
        statistics.assignAll(Map<String, dynamic>.from(statisticData));
      } else {
        statistics.clear();
      }

      // Pengaduan terbaru
      final complaintData = result['recent_complaints'];

      if (complaintData is List) {
        recentComplaints.assignAll(
          complaintData
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(),
        );
      } else {
        recentComplaints.clear();
      }
    } catch (e) {
      errorMessage.value = _messageFromError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await fetchDashboard();
  }

  // ==========================================
  // STATISTIK PENGADUAN
  // ==========================================

  int get totalPengaduan => _toInt(statistics['total']);

  int get pengaduanBaru => _toInt(statistics['baru']);

  int get pengaduanDitugaskan => _toInt(statistics['ditugaskan']);

  int get dalamPenanganan => _toInt(statistics['dalam_penanganan']);

  int get menungguVerifikasi => _toInt(statistics['menunggu_verifikasi']);

  int get pengaduanSelesai => _toInt(statistics['selesai']);

  // ==========================================
  // HELPER
  // ==========================================

  int _toInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _messageFromError(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return 'Terjadi kesalahan saat mengambil data dashboard.';
  }
}
