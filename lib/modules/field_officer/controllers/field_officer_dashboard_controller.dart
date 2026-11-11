import 'package:get/get.dart';
import 'package:sigapkawan/modules/field_officer/services/field_officer_service.dart';

class FieldOfficerDashboardController extends GetxController {
  final FieldOfficerService _service = FieldOfficerService();

  // Loading
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Statistik
  final statistics = <String, dynamic>{}.obs;

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
  // STATISTIK PENUGASAN
  // ==========================================

  int get totalTugas => _toInt(statistics['total']);

  int get tugasDiproses => _toInt(statistics['diproses']);

  int get menungguPemeriksaanUnit =>
      _toInt(statistics['menunggu_pemeriksaan_unit']);

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
