import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/data/services/berita_pengumuman_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitBeritaController extends GetxController {
  final BeritaPengumumanService _service = BeritaPengumumanService();

  final RxList<BeritaPengumumanModel> articles = <BeritaPengumumanModel>[].obs;

  final Rxn<BeritaPengumumanModel> selectedArticle =
      Rxn<BeritaPengumumanModel>();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString selectedJenis = 'semua'.obs;
  final RxString searchQuery = ''.obs;

  final searchController = TextEditingController();

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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // =======================================================
  // DAFTAR ARTIKEL
  // =======================================================

  Future<void> fetchArticles({bool refresh = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getAdminList(
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
    searchController.clear();
    searchQuery.value = '';
    await fetchArticles(refresh: true);
  }

  // =======================================================
  // TAMBAH ARTIKEL
  // =======================================================

  Future<bool> createArticle({
    required Map<String, dynamic> data,
    String? gambarPath,
  }) async {
    if (isSaving.value) return false;

    isSaving.value = true;

    try {
      await _service.create(data: data, gambarPath: gambarPath);

      Get.snackbar('Berhasil', 'Berita/pengumuman berhasil ditambahkan.');

      await fetchArticles(refresh: true);
      return true;
    } catch (e) {
      Get.snackbar('Gagal', _message(e));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // =======================================================
  // UPDATE ARTIKEL
  // =======================================================

  Future<bool> updateArticle({
    required int id,
    required Map<String, dynamic> data,
    String? gambarPath,
  }) async {
    if (isSaving.value) return false;

    isSaving.value = true;

    try {
      await _service.update(id: id, data: data, gambarPath: gambarPath);

      Get.snackbar('Berhasil', 'Berita/pengumuman berhasil diperbarui.');

      await fetchArticles(refresh: true);
      return true;
    } catch (e) {
      Get.snackbar('Gagal', _message(e));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // =======================================================
  // HAPUS ARTIKEL
  // =======================================================

  Future<bool> deleteArticle(int id) async {
    if (isDeleting.value) return false;

    isDeleting.value = true;

    try {
      await _service.delete(id);

      Get.snackbar('Berhasil', 'Berita/pengumuman berhasil dihapus.');

      await fetchArticles(refresh: true);
      return true;
    } catch (e) {
      Get.snackbar('Gagal', _message(e));
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  // =======================================================
  // PILIH ARTIKEL
  // =======================================================

  void selectArticle(BeritaPengumumanModel article) {
    selectedArticle.value = article;
  }

  void clearSelectedArticle() {
    selectedArticle.value = null;
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
