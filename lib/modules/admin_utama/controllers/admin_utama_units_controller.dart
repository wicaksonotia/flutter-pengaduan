import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapahub/app/data/models/unit_model.dart';
import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/admin_utama/services/admin_utama_units_service.dart';

class AdminUtamaUnitsController extends GetxController {
  final AdminUtamaUnitsService _service = AdminUtamaUnitsService();

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isSaving = false.obs;

  final errorMessage = ''.obs;

  final units = <UnitModel>[].obs;

  final selectedAktif = RxnBool();
  final searchQuery = ''.obs;

  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUnits();
  }

  Future<void> loadUnits({bool reset = true}) async {
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

      final response = await _service.getUnits(
        page: nextPage,
        aktif: selectedAktif.value,
        search: searchQuery.value,
      );

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

      currentPage.value =
          int.tryParse('${pagination['current_page']}') ?? nextPage;

      lastPage.value = int.tryParse('${pagination['last_page']}') ?? nextPage;

      total.value = int.tryParse('${pagination['total']}') ?? units.length;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> applyFilter({bool? aktif, bool clearAktif = false}) async {
    if (clearAktif) {
      selectedAktif.value = null;
    } else {
      selectedAktif.value = aktif;
    }

    await loadUnits();
  }

  Future<void> search(String value) async {
    searchQuery.value = value.trim();
    await loadUnits();
  }

  Future<void> loadMore() async {
    await loadUnits(reset: false);
  }

  Future<UnitModel?> getDetail(int id) async {
    try {
      final result = await _service.getUnitDetail(id);
      return UnitModel.fromJson(result);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<bool> saveUnit({int? id, required Map<String, dynamic> data}) async {
    if (isSaving.value) return false;

    isSaving.value = true;

    try {
      if (id == null) {
        await _service.createUnit(data);
      } else {
        await _service.updateUnit(id: id, data: data);
      }

      await loadUnits();

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
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> toggleUnitStatus(UnitModel unit) async {
    if (isSaving.value) return false;

    final newStatus = !unit.aktif;

    isSaving.value = true;

    try {
      await _service.updateUnit(id: unit.id, data: {'aktif': newStatus});

      await loadUnits();

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
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadUnits(reset: true);
  }
}
