import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:elingk/modules/admin_utama/services/admin_complaint_categories_service.dart';

class AdminComplaintCategoriesController extends GetxController {
  final AdminComplaintCategoriesService _service =
      AdminComplaintCategoriesService();

  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> units = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isLoadingUnits = false.obs;
  final RxBool selectedActive = true.obs;

  final RxnInt selectedUnitId = RxnInt();
  final RxString searchQuery = ''.obs;

  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();

  int? editingCategoryId;

  bool get isEditing => editingCategoryId != null;

  List<Map<String, dynamic>> get filteredCategories {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return categories.toList();
    }

    return categories.where((category) {
      final nama = (category['nama'] ?? '').toString().toLowerCase();
      final deskripsi = (category['deskripsi'] ?? '').toString().toLowerCase();
      final unit = _unitName(category).toLowerCase();

      return nama.contains(query) ||
          deskripsi.contains(query) ||
          unit.contains(query);
    }).toList();
  }

  int get totalCategories => categories.length;

  int get activeCategories => categories.where((category) {
    return _toBool(category['aktif']);
  }).length;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchUnits();
  }

  Future<void> fetchCategories() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final result = await _service.getCategories();
      categories.assignAll(result);
    } catch (e) {
      _showError('Gagal memuat kategori', _errorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnits() async {
    if (isLoadingUnits.value) return;

    isLoadingUnits.value = true;

    try {
      final result = await _service.getActiveUnits();
      units.assignAll(result);

      // Jangan mengubah pilihan saat edit jika unit tersebut masih ada.
      if (selectedUnitId.value != null &&
          !units.any((unit) => _toInt(unit['id']) == selectedUnitId.value)) {
        selectedUnitId.value = null;
      }
    } catch (e) {
      _showError('Gagal memuat unit', _errorMessage(e));
    } finally {
      isLoadingUnits.value = false;
    }
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  void setSelectedUnit(int? id) {
    selectedUnitId.value = id;
  }

  void setSelectedActive(bool value) {
    selectedActive.value = value;
  }

  void prepareCreate() {
    editingCategoryId = null;
    namaController.clear();
    deskripsiController.clear();
    selectedUnitId.value = null;
    selectedActive.value = true;
  }

  void prepareEdit(Map<String, dynamic> category) {
    editingCategoryId = _toInt(category['id']);

    namaController.text = (category['nama'] ?? '').toString();
    deskripsiController.text = (category['deskripsi'] ?? '').toString();

    selectedUnitId.value = _toInt(category['unit_id']);

    selectedActive.value = _toBool(category['aktif']);
  }

  Future<bool> saveCategory() async {
    final nama = namaController.text.trim();
    final deskripsi = deskripsiController.text.trim();
    final unitId = selectedUnitId.value;

    if (nama.isEmpty) {
      _showError('Validasi', 'Nama kategori wajib diisi.');
      return false;
    }

    if (unitId == null) {
      _showError('Validasi', 'Silakan pilih unit tujuan.');
      return false;
    }

    if (isSaving.value) return false;

    isSaving.value = true;

    try {
      if (isEditing) {
        await _service.updateCategory(
          id: editingCategoryId!,
          unitId: unitId,
          nama: nama,
          deskripsi: deskripsi.isEmpty ? null : deskripsi,
          aktif: selectedActive.value,
        );

        _showSuccess('Berhasil', 'Kategori berhasil diperbarui.');
      } else {
        await _service.createCategory(
          unitId: unitId,
          nama: nama,
          deskripsi: deskripsi.isEmpty ? null : deskripsi,
          aktif: selectedActive.value,
        );

        _showSuccess('Berhasil', 'Kategori berhasil ditambahkan.');
      }

      await fetchCategories();
      return true;
    } catch (e) {
      _showError('Gagal menyimpan kategori', _errorMessage(e));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    if (isDeleting.value) return false;

    isDeleting.value = true;

    try {
      await _service.deleteCategory(id);

      categories.removeWhere((category) => _toInt(category['id']) == id);

      _showSuccess('Berhasil', 'Kategori berhasil dihapus.');
      return true;
    } catch (e) {
      _showError('Gagal menghapus kategori', _errorMessage(e));
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  Future<bool> toggleCategoryActive(Map<String, dynamic> category) async {
    final id = _toInt(category['id']);
    final unitId = _toInt(category['unit_id']);
    final nama = (category['nama'] ?? '').toString().trim();

    if (id == null || unitId == null || nama.isEmpty) {
      _showError('Gagal mengubah status', 'Data kategori tidak lengkap.');
      return false;
    }

    final currentActive = _toBool(category['aktif']);
    final newActive = !currentActive;

    if (isSaving.value) {
      _showError(
        'Sedang diproses',
        'Tunggu proses penyimpanan lainnya selesai.',
      );
      return false;
    }

    isSaving.value = true;

    try {
      final updated = await _service.updateCategory(
        id: id,
        unitId: unitId,
        nama: nama,
        deskripsi: category['deskripsi']?.toString(),
        aktif: newActive,
      );

      final index = categories.indexWhere((item) => _toInt(item['id']) == id);

      if (index != -1) {
        categories[index] = {
          ...categories[index],
          ...updated,
          'aktif': newActive,
        };
        categories.refresh();
      }

      _showSuccess(
        'Berhasil',
        newActive
            ? 'Kategori berhasil diaktifkan.'
            : 'Kategori berhasil dinonaktifkan.',
      );

      return true;
    } catch (e) {
      _showError('Gagal mengubah status', _errorMessage(e));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  String _unitName(Map<String, dynamic> category) {
    final unit = category['unit'];

    if (unit is Map) {
      return (unit['nama'] ?? '').toString();
    }

    return '';
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    return value?.toString().toLowerCase() == 'true' ||
        value?.toString() == '1';
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        final errors = data['errors'];

        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;

          if (first is List && first.isNotEmpty) {
            return first.first.toString();
          }
        }

        if (data['message'] != null) {
          return data['message'].toString();
        }
      }

      if (error.response == null) {
        return 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
      }
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  void _showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
    );
  }

  @override
  void onClose() {
    namaController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }
}
