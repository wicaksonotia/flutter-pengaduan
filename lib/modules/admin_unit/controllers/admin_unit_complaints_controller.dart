import 'package:get/get.dart';
import 'package:elingk/modules/admin_unit/services/admin_unit_service.dart';

class AdminUnitComplaintsController extends GetxController {
  final AdminUnitService _service = AdminUnitService();

  final complaints = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;
  final selectedStatus = ''.obs;

  int _requestVersion = 0;

  bool get hasMore => currentPage.value < lastPage.value;

  @override
  void onInit() {
    super.onInit();
    fetchComplaints();
  }

  Future<void> fetchComplaints({bool refresh = false, String? status}) async {
    if (status != null) {
      selectedStatus.value = status;
    }

    final requestVersion = ++_requestVersion;

    if (refresh || status != null) {
      currentPage.value = 1;
    }

    isLoading.value = true;
    isLoadingMore.value = false;
    errorMessage.value = '';

    try {
      final result = await _service.getComplaints(
        page: currentPage.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      );

      if (requestVersion != _requestVersion) return;

      final pagination = result['data'];

      if (pagination is Map) {
        final items = _toComplaintList(pagination['data']);

        complaints.assignAll(items);
        currentPage.value = _toInt(pagination['current_page'], 1);
        lastPage.value = _toInt(pagination['last_page'], 1);
        total.value = _toInt(pagination['total'], items.length);
      } else if (pagination is List) {
        final items = _toComplaintList(pagination);

        complaints.assignAll(items);
        currentPage.value = 1;
        lastPage.value = 1;
        total.value = items.length;
      } else {
        complaints.clear();
        currentPage.value = 1;
        lastPage.value = 1;
        total.value = 0;
      }
    } catch (e) {
      if (requestVersion == _requestVersion) {
        errorMessage.value = _messageFromError(e);
      }
    } finally {
      if (requestVersion == _requestVersion) {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoading.value || isLoadingMore.value) return;

    final requestVersion = _requestVersion;
    final nextPage = currentPage.value + 1;

    isLoadingMore.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getComplaints(
        page: nextPage,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      );

      if (requestVersion != _requestVersion) return;

      final pagination = result['data'];

      if (pagination is Map) {
        complaints.addAll(_toComplaintList(pagination['data']));
        currentPage.value = _toInt(pagination['current_page'], nextPage);
        lastPage.value = _toInt(pagination['last_page'], lastPage.value);
        total.value = _toInt(pagination['total'], total.value);
      }
    } catch (e) {
      if (requestVersion == _requestVersion) {
        errorMessage.value = _messageFromError(e);
      }
    } finally {
      if (requestVersion == _requestVersion) {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> changeStatusFilter(String status) async {
    if (selectedStatus.value == status && complaints.isNotEmpty) {
      return;
    }

    await fetchComplaints(refresh: true, status: status);
  }

  Future<void> refreshComplaints() async {
    await fetchComplaints(refresh: true);
  }

  List<Map<String, dynamic>> _toComplaintList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int _toInt(dynamic value, int fallback) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  String _messageFromError(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return 'Terjadi kesalahan saat mengambil data pengaduan.';
  }
}
