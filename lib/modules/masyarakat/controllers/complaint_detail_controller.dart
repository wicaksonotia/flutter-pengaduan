import 'package:dio/dio.dart';
import 'package:elingk/core/network/api_client.dart';
import 'package:elingk/modules/masyarakat/views/complaints/complaint_service.dart';
import 'package:get/get.dart';

class ComplaintDetailController extends GetxController {
  ComplaintDetailController({required this.complaintId});

  final int complaintId;
  final ComplaintService _service = ComplaintService();

  final complaint = Rxn<Map<String, dynamic>>();
  final loading = true.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    loading.value = true;
    error.value = null;

    try {
      final response = await _service.getComplaintDetail(complaintId);
      final raw = response['data'];

      if (raw is! Map) {
        throw Exception('Data detail pengaduan tidak ditemukan.');
      }

      complaint.value = Map<String, dynamic>.from(raw);
    } catch (e) {
      error.value = errorMessage(e);
    } finally {
      loading.value = false;
    }
  }

  String errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      if (error.response?.statusCode == 404) {
        return 'Pengaduan tidak ditemukan atau tidak dapat diakses.';
      }

      return 'Tidak dapat mengambil detail pengaduan. Periksa koneksi.';
    }

    return 'Detail pengaduan gagal dimuat. Silakan coba lagi.';
  }

  List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
