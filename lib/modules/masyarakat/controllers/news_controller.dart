import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/data/services/berita_pengumuman_service.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  final BeritaPengumumanService _service = BeritaPengumumanService();

  // State
  final RxList<BeritaPengumumanModel> articles = <BeritaPengumumanModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString selectedJenis = 'semua'.obs;
  final RxString searchQuery = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxInt total = 0.obs;

  bool get hasNextPage => currentPage.value < lastPage.value;

  bool get isEmpty => articles.isEmpty && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  // =======================================================
  // DAFTAR BERITA & PENGUMUMAN
  // =======================================================

  Future<void> fetchArticles({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      currentPage.value = 1;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getPublicList(
        jenis: selectedJenis.value == 'semua' ? null : selectedJenis.value,
        search: searchQuery.value,
        perPage: 10,
        page: 1,
      );

      articles.assignAll(result.data.data);

      currentPage.value = result.data.currentPage;
      lastPage.value = result.data.lastPage;
      total.value = result.data.total;
    } catch (e) {
      errorMessage.value = _message(e);
    } finally {
      isLoading.value = false;
    }
  }

  // =======================================================
  // LOAD MORE
  // =======================================================

  Future<void> loadMore() async {
    if (!hasNextPage || isLoadingMore.value || isLoading.value) {
      return;
    }

    isLoadingMore.value = true;

    try {
      final result = await _service.getPublicList(
        jenis: selectedJenis.value == 'semua' ? null : selectedJenis.value,
        search: searchQuery.value,
        perPage: 10,
        page: currentPage.value + 1,
      );

      articles.addAll(result.data.data);

      currentPage.value = result.data.currentPage;
      lastPage.value = result.data.lastPage;
      total.value = result.data.total;
    } catch (e) {
      Get.snackbar('Gagal', _message(e));
    } finally {
      isLoadingMore.value = false;
    }
  }

  // =======================================================
  // FILTER JENIS
  // =======================================================

  Future<void> changeJenis(String jenis) async {
    if (selectedJenis.value == jenis) return;

    selectedJenis.value = jenis;
    await fetchArticles(refresh: true);
  }

  // =======================================================
  // SEARCH
  // =======================================================

  Future<void> search(String keyword) async {
    searchQuery.value = keyword.trim();
    await fetchArticles(refresh: true);
  }

  Future<void> clearSearch() async {
    searchQuery.value = '';
    await fetchArticles(refresh: true);
  }

  // =======================================================
  // REFRESH
  // =======================================================

  Future<void> refreshArticles() async {
    await fetchArticles(refresh: true);
  }

  String _message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
