import 'package:get/get.dart';
import 'package:elingk/modules/field_officer/services/field_officer_service.dart';

class FieldOfficerAssignmentsController extends GetxController {
  final FieldOfficerService _service = FieldOfficerService();

  final assignments = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;

  int _requestVersion = 0;

  bool get hasMore => currentPage.value < lastPage.value;

  @override
  void onInit() {
    super.onInit();
    fetchAssignments();
  }

  Future<void> fetchAssignments({bool refresh = false}) async {
    final requestVersion = ++_requestVersion;

    if (refresh) {
      currentPage.value = 1;
    }

    isLoading.value = true;
    isLoadingMore.value = false;
    errorMessage.value = '';

    try {
      final result = await _service.getAssignments(page: currentPage.value);

      if (requestVersion != _requestVersion) return;

      final pagination = result['data'];

      if (pagination is Map) {
        final items = _toList(pagination['data']);

        assignments.assignAll(items);
        currentPage.value = _toInt(pagination['current_page'], 1);
        lastPage.value = _toInt(pagination['last_page'], 1);
        total.value = _toInt(pagination['total'], items.length);
      } else if (pagination is List) {
        final items = _toList(pagination);

        assignments.assignAll(items);
        currentPage.value = 1;
        lastPage.value = 1;
        total.value = items.length;
      } else {
        assignments.clear();
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

  Future<void> refreshAssignments() async {
    await fetchAssignments(refresh: true);
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoading.value || isLoadingMore.value) {
      return;
    }

    final requestVersion = _requestVersion;
    final nextPage = currentPage.value + 1;

    isLoadingMore.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getAssignments(page: nextPage);

      if (requestVersion != _requestVersion) return;

      final pagination = result['data'];

      if (pagination is Map) {
        assignments.addAll(_toList(pagination['data']));

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

  List<Map<String, dynamic>> _toList(dynamic value) {
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

    return 'Terjadi kesalahan saat mengambil daftar tugas.';
  }
}
