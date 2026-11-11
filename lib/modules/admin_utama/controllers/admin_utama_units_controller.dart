import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sigapkawan/app/data/models/unit_model.dart';
import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_utama/services/admin_utama_units_service.dart';

class AdminUtamaUnitsController extends GetxController {
  final AdminUtamaUnitsService _service = AdminUtamaUnitsService();

  // Loading
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isSaving = false.obs;

  // State
  final errorMessage = ''.obs;
  final units = <UnitModel>[].obs;

  // Filter
  final selectedAktif = RxnBool();
  final searchQuery = ''.obs;

  // Pagination
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;

  // Penanda request agar respons lama tidak menimpa data terbaru.
  int _requestVersion = 0;

  @override
  void onInit() {
    super.onInit();
    loadUnits();
  }

  // ============================================================
  // LIST UNIT
  // ============================================================

  Future<void> loadUnits({bool reset = true}) async {
    late final int requestVersion;

    if (reset) {
      // Request reset selalu boleh berjalan meskipun request lama
      // masih berlangsung.
      requestVersion = ++_requestVersion;

      isLoading.value = true;
      isLoadingMore.value = false;

      currentPage.value = 1;
      errorMessage.value = '';
    } else {
      // Pagination tidak boleh berjalan bersamaan dengan request lain.
      if (isLoading.value || isLoadingMore.value) return;

      if (currentPage.value >= lastPage.value) return;

      requestVersion = _requestVersion;
      isLoadingMore.value = true;
    }

    try {
      final nextPage = reset ? 1 : currentPage.value + 1;

      final response = await _service.getUnits(
        page: nextPage,
        aktif: selectedAktif.value,
        search: searchQuery.value,
      );

      // Abaikan respons dari request yang sudah kedaluwarsa.
      if (requestVersion != _requestVersion) return;

      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Gagal mengambil daftar unit.');
      }

      final data = response['data'];

      if (data is! Map) {
        throw Exception('Data pagination unit tidak valid.');
      }

      final pagination = Map<String, dynamic>.from(data);
      final rawItems = pagination['data'];

      if (rawItems is! List) {
        throw Exception('Daftar unit tidak valid.');
      }

      final items = rawItems
          .whereType<Map>()
          .map((item) => UnitModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      if (reset) {
        units.assignAll(items);
      } else {
        units.addAll(items);
      }

      currentPage.value = _toInt(pagination['current_page'], nextPage);

      lastPage.value = _toInt(pagination['last_page'], nextPage);

      total.value = _toInt(pagination['total'], units.length);
    } catch (e) {
      if (requestVersion == _requestVersion) {
        errorMessage.value = _errorMessage(e);
      }
    } finally {
      // Request lama tidak boleh mengubah status loading
      // milik request yang lebih baru.
      if (requestVersion == _requestVersion) {
        if (reset) {
          isLoading.value = false;
        } else {
          isLoadingMore.value = false;
        }
      }
    }
  }

  // ============================================================
  // FILTER & SEARCH
  // ============================================================

  Future<void> applyFilter({bool? aktif, bool clearAktif = false}) async {
    selectedAktif.value = clearAktif ? null : aktif;
    await loadUnits(reset: true);
  }

  Future<void> search(String value) async {
    searchQuery.value = value.trim();
    await loadUnits(reset: true);
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  Future<void> loadMore() async {
    await loadUnits(reset: false);
  }

  // ============================================================
  // DETAIL
  // ============================================================

  Future<UnitModel?> getDetail(int id) async {
    try {
      final result = await _service.getUnitDetail(id);
      return UnitModel.fromJson(result);
    } catch (e) {
      _showError(_errorMessage(e));
      return null;
    }
  }

  // ============================================================
  // CREATE & UPDATE
  // ============================================================

  Future<bool> saveUnit({int? id, required Map<String, dynamic> data}) async {
    if (isSaving.value) return false;

    isSaving.value = true;

    try {
      if (id == null) {
        await _service.createUnit(data);
      } else {
        await _service.updateUnit(id: id, data: data);
      }

      // Reset request tetap dijalankan walaupun sebelumnya
      // masih ada request daftar unit yang berlangsung.
      await loadUnits(reset: true);

      Get.snackbar(
        'Berhasil',
        id == null ? 'Unit berhasil ditambahkan.' : 'Unit berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.blue,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Gagal',
        _service.getErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ============================================================
  // ACTIVATE & DEACTIVATE
  // ============================================================

  Future<bool> toggleUnitStatus(UnitModel unit) async {
    if (isSaving.value) return false;

    final newStatus = !unit.aktif;

    isSaving.value = true;

    try {
      await _service.updateUnit(id: unit.id, data: {'aktif': newStatus});

      await loadUnits(reset: true);

      Get.snackbar(
        'Berhasil',
        newStatus
            ? 'Unit berhasil diaktifkan.'
            : 'Unit berhasil dinonaktifkan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.blue,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      _showError(_errorMessage(e));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshUnits() async {
    await loadUnits(reset: true);
  }

  // ============================================================
  // HELPERS
  // ============================================================

  int _toInt(dynamic value, int fallback) {
    if (value is int) return value;
    return int.tryParse('$value') ?? fallback;
  }

  String _errorMessage(dynamic error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  void _showError(String message) {
    Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
  }
}
