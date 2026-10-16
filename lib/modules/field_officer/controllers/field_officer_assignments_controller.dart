import 'package:dio/dio.dart';
import 'package:elingk/modules/field_officer/services/field_officer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldOfficerAssignmentsController extends GetxController {
  final FieldOfficerService _service = FieldOfficerService();

  final assignments = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;

  final error = RxnString();

  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;

  final selectedStatus = ''.obs;

  final summary = <String, int>{
    'total': 0,
    // 'ditugaskan': 0,
    'diproses': 0,
    'menunggu_pemeriksaan_unit': 0,
  }.obs;

  bool get hasMore => currentPage.value < lastPage.value;

  @override
  void onInit() {
    super.onInit();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    if (isLoading.value) return;

    isLoading.value = true;
    error.value = null;

    try {
      await _fetchPage(reset: true);
    } catch (e) {
      error.value = _messageFromError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAssignments() async {
    if (isRefreshing.value || isLoading.value) return;

    isRefreshing.value = true;
    error.value = null;

    try {
      await _fetchPage(reset: true);
    } catch (e) {
      error.value = _messageFromError(e);
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> applyFilter({required String status}) async {
    if (selectedStatus.value == status) return;

    selectedStatus.value = status;
    currentPage.value = 1;
    assignments.clear();
    error.value = null;

    await loadAssignments();
  }

  Future<void> _fetchPage({required bool reset}) async {
    final result = await _service.getAssignments(
      page: 1,
      status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
    );

    final pagination = _extractPagination(result);

    if (reset) {
      assignments.assignAll(pagination.items);
    } else {
      assignments.addAll(pagination.items);
    }

    currentPage.value = pagination.currentPage;
    lastPage.value = pagination.lastPage;
    total.value = pagination.total;

    final rawSummary = result['summary'];

    if (rawSummary is Map) {
      for (final key in summary.keys.toList()) {
        final value = rawSummary[key];
        summary[key] = _toInt(value) ?? 0;
      }
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value ||
        isRefreshing.value ||
        isLoadingMore.value ||
        !hasMore) {
      return;
    }

    isLoadingMore.value = true;

    try {
      final nextPage = currentPage.value + 1;

      final result = await _service.getAssignments(
        page: nextPage,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      );

      final pagination = _extractPagination(result);

      final existingIds = assignments
          .map((item) => item['id']?.toString())
          .toSet();

      assignments.addAll(
        pagination.items.where(
          (item) => !existingIds.contains(item['id']?.toString()),
        ),
      );

      currentPage.value = pagination.currentPage;
      lastPage.value = pagination.lastPage;
      total.value = pagination.total;
    } catch (e) {
      Get.snackbar(
        'Gagal memuat tugas',
        _messageFromError(e),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  _AssignmentPagination _extractPagination(Map<String, dynamic> result) {
    final rawData = result['data'];

    if (rawData is Map) {
      final pageData = Map<String, dynamic>.from(rawData);
      final items = _mapList(pageData['data']);

      return _AssignmentPagination(
        items: items,
        currentPage: _toInt(pageData['current_page']) ?? 1,
        lastPage: _toInt(pageData['last_page']) ?? 1,
        total: _toInt(pageData['total']) ?? items.length,
      );
    }

    if (rawData is List) {
      final items = _mapList(rawData);

      return _AssignmentPagination(
        items: items,
        currentPage: 1,
        lastPage: 1,
        total: items.length,
      );
    }

    throw Exception('Format daftar penugasan tidak valid.');
  }

  List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  String _messageFromError(Object exception) {
    if (exception is DioException) {
      final responseData = exception.response?.data;

      if (responseData is Map) {
        final message = responseData['message'];

        if (message != null && message.toString().isNotEmpty) {
          return message.toString();
        }
      }

      if (exception.response == null) {
        return 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
      }

      return 'Terjadi kesalahan saat menghubungi server.';
    }

    return exception.toString().replaceFirst('Exception: ', '');
  }
}

class _AssignmentPagination {
  final List<Map<String, dynamic>> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const _AssignmentPagination({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}
