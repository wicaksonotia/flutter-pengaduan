import 'package:dio/dio.dart';
import 'package:sigapkawan/modules/admin_utama/services/admin_complaints_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AdminComplaintDetailController extends GetxController {
  AdminComplaintDetailController({required this.complaintId});

  final int complaintId;
  final AdminComplaintsService _service = AdminComplaintsService();

  final complaint = Rxn<Map<String, dynamic>>();
  final categories = <Map<String, dynamic>>[].obs;
  final units = <Map<String, dynamic>>[].obs;

  final loading = true.obs;
  final loadingCategories = false.obs;
  final loadingUnits = false.obs;
  final actionLoading = false.obs;
  final error = RxnString();

  String? get status => complaint.value?['status']?.toString();

  bool get canManageComplaint =>
      status == 'diajukan' || status == 'dikembalikan';

  bool get canVerifyComplaint => status == 'menunggu_verifikasi';

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    loading.value = true;
    error.value = null;

    try {
      complaint.value = await _service.getComplaintDetail(complaintId);
    } catch (e) {
      error.value = errorMessage(e);
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadCategories() async {
    loadingCategories.value = true;

    try {
      categories.assignAll(await _service.getCategories());
    } catch (e) {
      throw Exception(errorMessage(e));
    } finally {
      loadingCategories.value = false;
    }
  }

  Future<void> loadUnits() async {
    loadingUnits.value = true;

    try {
      units.assignAll(await _service.getUnits());
    } catch (e) {
      throw Exception(errorMessage(e));
    } finally {
      loadingUnits.value = false;
    }
  }

  Future<void> setCategory(int categoryId) async {
    _ensureCanManage();
    await _runAction(() async {
      await _service.setCategory(
        complaintId: complaintId,
        categoryId: categoryId,
      );
    });
  }

  Future<void> delegate({required int unitId, String? catatan}) async {
    _ensureCanManage();
    await _runAction(() async {
      await _service.delegate(
        complaintId: complaintId,
        unitId: unitId,
        catatan: catatan,
      );
    });
  }

  Future<void> reject(String catatan) async {
    _ensureCanManage();

    if (catatan.trim().length < 5) {
      throw Exception('Alasan penolakan minimal 5 karakter.');
    }

    await _runAction(() async {
      await _service.reject(complaintId: complaintId, catatan: catatan);
    });
  }

  Future<void> verify({required String keputusan, String? catatan}) async {
    if (!canVerifyComplaint) {
      throw Exception('Pengaduan ini tidak sedang menunggu verifikasi.');
    }

    if (!['disetujui', 'ditolak'].contains(keputusan)) {
      throw Exception('Keputusan verifikasi tidak valid.');
    }

    if (keputusan == 'ditolak' &&
        (catatan == null || catatan.trim().length < 5)) {
      throw Exception('Alasan penolakan hasil penanganan minimal 5 karakter.');
    }

    await _runAction(() async {
      await _service.verifyComplaint(
        complaintId: complaintId,
        keputusan: keputusan,
        catatan: catatan,
      );
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    if (actionLoading.value) return;

    actionLoading.value = true;

    try {
      await action();
      await _reloadAfterAction();
    } finally {
      actionLoading.value = false;
    }
  }

  Future<void> _reloadAfterAction() async {
    complaint.value = await _service.getComplaintDetail(complaintId);
    error.value = null;
  }

  void _ensureCanManage() {
    if (!canManageComplaint) {
      throw Exception(
        'Tindakan hanya dapat dilakukan pada pengaduan berstatus diajukan atau dikembalikan.',
      );
    }
  }

  List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        final message = data['message'];

        if (message != null) return message.toString();

        final errors = data['errors'];

        if (errors is Map) {
          for (final value in errors.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
          }
        }
      }

      switch (error.response?.statusCode) {
        case 401:
          return 'Sesi login berakhir. Silakan login kembali.';
        case 403:
          return 'Kamu tidak memiliki akses ke tindakan ini.';
        case 404:
          return 'Pengaduan atau data tujuan tidak ditemukan.';
        case 422:
          return 'Data tidak valid atau status pengaduan sudah berubah.';
      }

      return 'Tidak dapat menghubungi server. Periksa koneksi.';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  void onClose() {
    debugPrint('AdminComplaintDetailController ditutup: $complaintId');
    super.onClose();
  }
}
