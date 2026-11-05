import 'package:sapahub/app/data/models/berita_pengumuman_model.dart';
import 'package:sapahub/app/data/services/berita_pengumuman_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitBeritaController extends GetxController {
  final BeritaPengumumanService _service = BeritaPengumumanService();

  final RxList<BeritaPengumumanModel> articles = <BeritaPengumumanModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString selectedJenis = 'semua'.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();

  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxInt total = 0.obs;

  int _requestVersion = 0;

  bool get hasNextPage => currentPage.value < lastPage.value;

  bool get isEmpty => articles.isEmpty && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  String _message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> fetchArticles({bool refresh = false}) async {
    final requestVersion = ++_requestVersion;

    isLoading.value = true;
    errorMessage.value = '';

    if (refresh) {
      currentPage.value = 1;
    }

    try {
      final result = await _service.getAdminList(
        jenis: selectedJenis.value == 'semua' ? null : selectedJenis.value,
        search: searchQuery.value,
        perPage: 10,
        page: 1,
      );

      // Abaikan respons lama jika filter/search sudah berubah.
      if (requestVersion != _requestVersion) return;

      articles.assignAll(result.data.data);
      currentPage.value = result.data.currentPage;
      lastPage.value = result.data.lastPage;
      total.value = result.data.total;
    } catch (e) {
      if (requestVersion != _requestVersion) return;
      errorMessage.value = _message(e);
    } finally {
      if (requestVersion == _requestVersion) {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadMore() async {
    if (!hasNextPage || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;

    try {
      final result = await _service.getAdminList(
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
      Get.snackbar(
        'Gagal memuat data',
        _message(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> changeJenis(String jenis) async {
    if (selectedJenis.value == jenis) return;

    selectedJenis.value = jenis;
    await fetchArticles(refresh: true);
  }

  Future<void> search(String keyword) async {
    searchQuery.value = keyword.trim();
    await fetchArticles(refresh: true);
  }

  Future<void> clearSearch() async {
    searchController.clear();
    searchQuery.value = '';
    await fetchArticles(refresh: true);
  }

  Future<void> refreshArticles() async {
    await fetchArticles(refresh: true);
  }

  Future<bool> createArticle({
    required Map<String, dynamic> data,
    String? gambarPath,
  }) async {
    if (isSaving.value) return false;

    isSaving.value = true;

    try {
      await _service.create(data: data, gambarPath: gambarPath);

      Get.snackbar(
        'Berhasil',
        'Berita berhasil ditambahkan.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await fetchArticles(refresh: true);
      return true;
    } catch (e) {
      Get.snackbar('Gagal', _message(e), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateArticle({
    required int id,
    required Map<String, dynamic> data,
    String? gambarPath,
  }) async {
    if (isSaving.value) return false;

    isSaving.value = true;

    try {
      await _service.update(id: id, data: data, gambarPath: gambarPath);

      Get.snackbar(
        'Berhasil',
        'Berita berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await fetchArticles(refresh: true);
      return true;
    } catch (e) {
      Get.snackbar('Gagal', _message(e), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteArticle(int id) async {
    if (isDeleting.value) return false;

    isDeleting.value = true;

    try {
      await _service.delete(id);

      Get.snackbar(
        'Berhasil',
        'Berita berhasil dihapus.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await fetchArticles(refresh: true);
      return true;
    } catch (e) {
      Get.snackbar('Gagal', _message(e), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isDeleting.value = false;
    }
  }
}
