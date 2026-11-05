import 'package:get/get.dart';
import 'package:sapahub/modules/masyarakat/services/masyarakat_dashboard_service.dart';

class MasyarakatDashboardController extends GetxController {
  final MasyarakatDashboardService _service = MasyarakatDashboardService();

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

      final statisticData = result['statistics'];

      if (statisticData is Map) {
        statistics.assignAll(Map<String, dynamic>.from(statisticData));
      } else {
        statistics.clear();
      }

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

  // Statistik pengaduan

  int get totalPengaduan => _toInt(statistics['total']);

  int get pengaduanBaru => _toInt(statistics['baru']);

  int get pengaduanDitugaskan => _toInt(statistics['ditugaskan']);

  int get dalamPenanganan => _toInt(statistics['dalam_penanganan']);

  int get menungguVerifikasi => _toInt(statistics['menunggu_verifikasi']);

  int get pengaduanSelesai => _toInt(statistics['selesai']);

  // Helper

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
