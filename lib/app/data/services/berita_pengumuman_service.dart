import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/core/network/api_client.dart';

class BeritaPengumumanService {
  static const String _publicEndpoint = '/berita-pengumuman';
  static const String _adminEndpoint = '/admin/berita-pengumuman';

  // =======================================================
  // PUBLIC: DAFTAR BERITA & PENGUMUMAN
  // =======================================================

  Future<BeritaPengumumanListResponse> getPublicList({
    int? instansiId,
    String? jenis,
    String? search,
    int perPage = 10,
    int page = 1,
  }) async {
    final params = <String, dynamic>{'per_page': perPage, 'page': page};

    if (instansiId != null) {
      params['instansi_id'] = instansiId;
    }

    if (jenis != null && jenis.isNotEmpty) {
      params['jenis'] = jenis;
    }

    if (search != null && search.trim().isNotEmpty) {
      params['search'] = search.trim();
    }

    try {
      final response = await ApiClient.dio.get(
        _publicEndpoint,
        queryParameters: params,
      );

      final json = _validateResponse(response.data);

      return BeritaPengumumanListResponse.fromJson(json);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // =======================================================
  // PUBLIC: DETAIL BERITA & PENGUMUMAN
  // =======================================================

  Future<BeritaPengumumanModel> getPublicDetail(int id) async {
    try {
      final response = await ApiClient.dio.get('$_publicEndpoint/$id');

      final json = _validateResponse(response.data);

      return _parseArticle(json);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // =======================================================
  // ADMIN: DAFTAR BERITA & PENGUMUMAN
  // Admin Utama dan Admin Unit
  // =======================================================

  Future<BeritaPengumumanListResponse> getAdminList({
    int? instansiId,
    String? jenis,
    String? search,
    int? perPage,
    int page = 1,
  }) async {
    final params = <String, dynamic>{'page': page};

    if (instansiId != null) {
      params['instansi_id'] = instansiId;
    }

    if (jenis != null && jenis.isNotEmpty) {
      params['jenis'] = jenis;
    }

    if (search != null && search.trim().isNotEmpty) {
      params['search'] = search.trim();
    }

    if (perPage != null) {
      params['per_page'] = perPage;
    }

    try {
      final response = await ApiClient.dio.get(
        _adminEndpoint,
        queryParameters: params,
      );

      final json = _validateResponse(response.data);

      return BeritaPengumumanListResponse.fromJson(json);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // =======================================================
  // ADMIN: TAMBAH BERITA & PENGUMUMAN
  // =======================================================

  Future<BeritaPengumumanModel> create({
    required Map<String, dynamic> data,
    String? gambarPath,
  }) async {
    try {
      final requestData = await _buildRequestData(
        data: data,
        gambarPath: gambarPath,
      );

      final response = await ApiClient.dio.post(
        _adminEndpoint,
        data: requestData,
        options: Options(
          contentType: requestData is FormData
              ? Headers.multipartFormDataContentType
              : Headers.jsonContentType,
        ),
      );

      final json = _validateResponse(response.data);

      return _parseArticle(json);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // =======================================================
  // ADMIN: UPDATE BERITA & PENGUMUMAN
  // =======================================================

  Future<BeritaPengumumanModel> update({
    required int id,
    required Map<String, dynamic> data,
    String? gambarPath,
  }) async {
    try {
      final requestData = await _buildRequestData(
        data: data,
        gambarPath: gambarPath,
      );

      final response = await ApiClient.dio.post(
        '$_adminEndpoint/$id',
        data: requestData,
        options: Options(
          contentType: requestData is FormData
              ? Headers.multipartFormDataContentType
              : Headers.jsonContentType,
        ),
      );

      final json = _validateResponse(response.data);

      return _parseArticle(json);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // =======================================================
  // ADMIN: HAPUS BERITA & PENGUMUMAN
  // =======================================================

  Future<void> delete(int id) async {
    try {
      final response = await ApiClient.dio.delete('$_adminEndpoint/$id');

      _validateResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // =======================================================
  // PRIVATE: MEMBANGUN REQUEST DATA
  // =======================================================

  Future<dynamic> _buildRequestData({
    required Map<String, dynamic> data,
    String? gambarPath,
  }) async {
    final fields = <String, dynamic>{};

    data.forEach((key, value) {
      // gambar dikirim melalui MultipartFile,
      // bukan sebagai string path.
      if (key == 'gambar') return;

      if (value is DateTime) {
        fields[key] = value.toIso8601String();
      } else {
        fields[key] = value;
      }
    });

    if (gambarPath == null || gambarPath.isEmpty) {
      return fields;
    }

    final file = File(gambarPath);

    if (!await file.exists()) {
      throw Exception('File gambar tidak ditemukan.');
    }

    fields['gambar'] = await MultipartFile.fromFile(
      gambarPath,
      filename: gambarPath.split('/').last,
    );

    return FormData.fromMap(fields);
  }

  // =======================================================
  // PRIVATE: VALIDASI RESPONSE
  // =======================================================

  Map<String, dynamic> _validateResponse(dynamic responseData) {
    if (responseData is! Map) {
      throw Exception('Format respons server tidak valid.');
    }

    final json = Map<String, dynamic>.from(responseData);

    if (json['status'] == false ||
        json['status'] == 'error' ||
        json['success'] == false) {
      throw Exception(
        json['message']?.toString() ?? 'Permintaan tidak berhasil.',
      );
    }

    return json;
  }

  // =======================================================
  // PRIVATE: PARSING ARTIKEL
  // =======================================================

  BeritaPengumumanModel _parseArticle(Map<String, dynamic> json) {
    final data = json['data'];

    if (data is! Map) {
      throw Exception('Data artikel tidak ditemukan.');
    }

    return BeritaPengumumanModel.fromJson(Map<String, dynamic>.from(data));
  }

  // =======================================================
  // PRIVATE: ERROR MESSAGE
  // =======================================================

  String _getErrorMessage(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map) {
      final message = responseData['message'];

      if (message != null) {
        return message.toString();
      }

      // Laravel validation errors
      final errors = responseData['errors'];

      if (errors is Map && errors.isNotEmpty) {
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
    }

    return error.message ?? 'Terjadi kesalahan pada server.';
  }
}
