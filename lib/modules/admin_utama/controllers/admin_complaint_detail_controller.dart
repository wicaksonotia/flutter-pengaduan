import 'package:dio/dio.dart';
import 'package:elingk/core/network/api_client.dart';
import 'package:elingk/modules/admin_utama/services/admin_complaints_service.dart';
import 'package:get/get.dart';

class AdminComplaintDetailController extends GetxController {
  AdminComplaintDetailController({required this.complaintId});

  final int complaintId;
  final AdminComplaintsService _service = AdminComplaintsService();

  final complaint = Rxn<Map<String, dynamic>>();
  final loading = true.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    if (loading.value && complaint.value != null) return;

    loading.value = true;
    error.value = null;

    try {
      final result = await _service.getComplaintDetail(complaintId);
      complaint.value = result;
    } catch (e) {
      error.value = _errorMessage(e);
    } finally {
      loading.value = false;
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      if (error.response?.statusCode == 404) {
        return 'Pengaduan tidak ditemukan atau tidak dapat diakses.';
      }

      if (error.response?.statusCode == 401) {
        return 'Sesi login berakhir. Silakan login kembali.';
      }

      if (error.response?.statusCode == 403) {
        return 'Kamu tidak memiliki akses ke pengaduan ini.';
      }

      return 'Tidak dapat mengambil detail pengaduan. Periksa koneksi.';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String imageUrl(dynamic value) {
    final path = (value ?? '').toString().trim();

    if (path.isEmpty) return '';

    final uri = Uri.tryParse(path);

    if (uri != null && uri.hasScheme) {
      return path;
    }

    return Uri.parse(ApiClient.dio.options.baseUrl).resolve(path).toString();
  }
}
