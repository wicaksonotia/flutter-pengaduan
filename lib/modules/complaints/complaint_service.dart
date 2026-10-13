import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';

class ComplaintService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getComplaints({int page = 1}) async {
    final response = await _dio.get(
      '/complaints',
      queryParameters: {'page': page},
    );

    if (response.data is! Map) {
      throw Exception('Format respons pengaduan tidak valid.');
    }

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getComplaintDetail(int id) async {
    final response = await _dio.get('/complaints/$id');

    if (response.data is! Map) {
      throw Exception('Format detail pengaduan tidak valid.');
    }

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> createComplaint({
    required String judul,
    required String isiPengaduan,
    required double latitude,
    required double longitude,
    String? alamat,
    required List<String> photoPaths,
  }) async {
    if (photoPaths.isEmpty || photoPaths.length > 5) {
      throw Exception('Pilih minimal 1 dan maksimal 5 foto.');
    }

    final Map<String, dynamic> data = {
      'judul': judul,
      'isi_pengaduan': isiPengaduan,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      if (alamat != null && alamat.trim().isNotEmpty) 'alamat': alamat.trim(),
    };

    for (var i = 0; i < photoPaths.length; i++) {
      data['photos[$i]'] = await MultipartFile.fromFile(
        photoPaths[i],
        filename: photoPaths[i].split('/').last,
      );
    }

    final formData = FormData.fromMap(data);

    final response = await _dio.post(
      '/complaints',
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );

    if (response.data is! Map) {
      throw Exception('Format respons pengiriman pengaduan tidak valid.');
    }

    return Map<String, dynamic>.from(response.data as Map);
  }
}
