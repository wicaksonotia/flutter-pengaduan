import 'package:elingk/modules/masyarakat/views/complaints/complaint_service.dart';
import 'package:get/get.dart';

class ComplaintListController extends GetxController {
  final ComplaintService _service = ComplaintService();

  final RxList<Map<String, dynamic>> complaints = <Map<String, dynamic>>[].obs;

  final RxBool loading = true.obs;
  final RxnString error = RxnString();
  final RxInt total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    loading.value = true;
    error.value = null;

    try {
      final response = await _service.getComplaints();
      final pagination = response['data'];
      final rawData = pagination is Map ? pagination['data'] : null;

      final items = rawData is List
          ? rawData
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
          : <Map<String, dynamic>>[];

      final parsedTotal = pagination is Map
          ? int.tryParse('${pagination['total'] ?? items.length}')
          : null;

      complaints.assignAll(items);
      total.value = parsedTotal ?? items.length;
    } catch (_) {
      error.value = 'Gagal memuat pengaduan. Periksa koneksi lalu coba lagi.';
    } finally {
      loading.value = false;
    }
  }
}
