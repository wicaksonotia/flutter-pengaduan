import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';

class AuthService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> requestOtp(String phone) async {
    final response = await _dio.post(
      '/auth/phone/request-otp',
      data: {'phone': phone},
    );

    final result = _asMap(response.data);
    final rawData = result['data'];

    final data = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{};

    // Simpan informasi OTP development agar bisa ditampilkan
    // oleh LoginView/OtpView saat pengujian.
    return {
      ...result,
      'data': data,
      'development_otp': data['otp']?.toString(),
    };
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _dio.post(
      '/auth/phone/verify-otp',
      data: {'phone': phone, 'otp': otp},
    );

    final data = _asMap(response.data);

    final nestedData = data['data'] is Map
        ? Map<String, dynamic>.from(data['data'] as Map)
        : <String, dynamic>{};

    final token = data['token'] ?? nestedData['token'];

    if (token == null || token.toString().isEmpty) {
      throw Exception(
        'Login belum menghasilkan token. '
        'Periksa format respons API Laravel.',
      );
    }

    await TokenStorage.saveToken(token.toString());

    return data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/me');

    debugPrint('=== RESPONS API /me ===');
    debugPrint(response.data.toString());
    debugPrint('=== AKHIR RESPONS API /me ===');

    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
  }) async {
    final response = await _dio.put(
      '/me',
      data: {'name': name, 'email': email.isEmpty ? null : email},
    );

    return _asMap(response.data);
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } finally {
      await TokenStorage.deleteToken();
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw Exception('Format respons server tidak valid.');
  }
}
