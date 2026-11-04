import 'package:dio/dio.dart';
import 'package:elingk/core/network/api_client.dart';

class FieldOfficerService {
  final Dio _dio = ApiClient.dio;

  // ==========================================
  // DASHBOARD
  // ==========================================

  /// Mengambil statistik dashboard Field Officer.
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _dio.get('/field/dashboard');
    final result = _asMap(response.data);

    _validateResponse(
      result,
      fallbackMessage: 'Gagal mengambil data dashboard.',
    );

    if (result['data'] is! Map) {
      throw Exception('Format data dashboard tidak valid.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }

  // ==========================================
  // DAFTAR PENUGASAN
  // ==========================================

  Future<Map<String, dynamic>> getAssignments({
    int page = 1,
    String? status,
  }) async {
    final response = await _dio.get(
      '/field/assignments',
      queryParameters: {
        'page': page,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );

    final result = _asMap(response.data);

    _validateResponse(
      result,
      fallbackMessage: 'Gagal mengambil daftar penugasan.',
    );

    return result;
  }

  // ==========================================
  // DETAIL PENUGASAN
  // ==========================================

  Future<Map<String, dynamic>> getAssignmentDetail(int id) async {
    final response = await _dio.get('/field/assignments/$id');
    final result = _asMap(response.data);

    _validateResponse(
      result,
      fallbackMessage: 'Gagal mengambil detail penugasan.',
    );

    if (result['data'] is! Map) {
      throw Exception('Format detail penugasan tidak valid.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }

  // ==========================================
  // SUBMIT HASIL PENANGANAN
  // ==========================================

  Future<Map<String, dynamic>> submitAssignment({
    required int assignmentId,
    required String catatan,
    required List<String> photoPaths,
  }) async {
    if (photoPaths.isEmpty || photoPaths.length > 5) {
      throw Exception('Pilih minimal 1 dan maksimal 5 foto bukti.');
    }

    final formData = FormData();

    formData.fields.add(MapEntry('catatan', catatan));

    for (final path in photoPaths) {
      formData.files.add(
        MapEntry('photos[]', await MultipartFile.fromFile(path)),
      );
    }

    final response = await _dio.post(
      '/field/assignments/$assignmentId/submit',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final result = _asMap(response.data);

    _validateResponse(
      result,
      fallbackMessage: 'Gagal mengirim hasil penanganan.',
    );

    return result;
  }

  // ==========================================
  // RESPONSE HELPER
  // ==========================================

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw Exception('Format respons server tidak valid.');
  }

  void _validateResponse(
    Map<String, dynamic> result, {
    required String fallbackMessage,
  }) {
    if (result['status'] == 'error' || result['success'] == false) {
      throw Exception(result['message'] ?? fallbackMessage);
    }
  }
}
