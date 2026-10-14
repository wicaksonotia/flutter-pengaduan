import 'package:elingk/modules/admin_utama/services/admin_complaints_service.dart';
import 'package:get/get.dart';

class AdminComplaintsController extends GetxController {
  final AdminComplaintsService _service = AdminComplaintsService();

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  final complaints = <Map<String, dynamic>>[].obs;
  final selectedStatus = ''.obs;
  final belumDidelegasikan = false.obs;

  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadComplaints();
  }

  Future<void> loadComplaints({bool reset = true}) async {
    if (isLoading.value || isLoadingMore.value) return;

    if (reset) {
      isLoading.value = true;
      currentPage.value = 1;
      errorMessage.value = '';
    } else {
      if (currentPage.value >= lastPage.value) return;

      isLoadingMore.value = true;
    }

    try {
      final nextPage = reset ? 1 : currentPage.value + 1;

      final response = await _service.getComplaints(
        page: nextPage,
        status: selectedStatus.value,
        belumDidelegasikan: belumDidelegasikan.value,
      );

      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Gagal mengambil pengaduan.');
      }

      final data = response['data'];

      if (data is! Map) {
        throw Exception('Data pagination pengaduan tidak valid.');
      }

      final pagination = Map<String, dynamic>.from(data);
      final rawItems = pagination['data'];

      if (rawItems is! List) {
        throw Exception('Daftar pengaduan tidak valid.');
      }

      final items = rawItems
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      if (reset) {
        complaints.assignAll(items);
      } else {
        complaints.addAll(items);
      }

      currentPage.value =
          int.tryParse('${pagination['current_page']}') ?? nextPage;

      lastPage.value = int.tryParse('${pagination['last_page']}') ?? nextPage;

      total.value = int.tryParse('${pagination['total']}') ?? complaints.length;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> applyFilter({
    String? status,
    bool? hanyaBelumDidelegasikan,
  }) async {
    selectedStatus.value = status ?? '';
    belumDidelegasikan.value = hanyaBelumDidelegasikan ?? false;

    await loadComplaints();
  }

  Future<void> loadMore() async {
    await loadComplaints(reset: false);
  }

  @override
  Future<void> refresh() async {
    await loadComplaints();
  }
}
