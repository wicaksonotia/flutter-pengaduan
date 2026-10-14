import 'package:dio/dio.dart';
import 'package:elingk/modules/auth/auth_service.dart';
import 'package:elingk/modules/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  ProfileController({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  final isLoading = true.obs;
  final isSaving = false.obs;
  final user = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (isSaving.value) return;

    isLoading.value = true;

    try {
      final response = await _authService.getMe();
      user.assignAll(_extractUser(response));
    } catch (error) {
      showMessage(errorMessage(error), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _extractUser(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is Map) {
      final nestedUser = data['user'];

      if (nestedUser is Map) {
        return Map<String, dynamic>.from(nestedUser);
      }

      return Map<String, dynamic>.from(data);
    }

    final responseUser = response['user'];

    if (responseUser is Map) {
      return Map<String, dynamic>.from(responseUser);
    }

    return {};
  }

  Future<bool> saveProfile({
    required String name,
    required String email,
  }) async {
    if (isSaving.value) return false;

    isSaving.value = true;

    try {
      final response = await _authService.updateProfile(
        name: name,
        email: email,
      );

      final data = response['data'];

      if (data is Map) {
        final nestedUser = data['user'];

        if (nestedUser is Map) {
          user.assignAll(Map<String, dynamic>.from(nestedUser));
        } else {
          user.assignAll({...user, ...Map<String, dynamic>.from(data)});
        }
      } else {
        user.assignAll({...user, 'name': name, 'email': email});
      }

      showMessage(
        response['message']?.toString() ?? 'Profil berhasil diperbarui.',
      );

      return true;
    } catch (error) {
      showMessage(errorMessage(error), isError: true);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> confirmLogout(BuildContext context) async {
    if (isSaving.value) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Keluar dari akun?'),
          content: const Text(
            'Kamu perlu login kembali untuk menggunakan layanan eLingk.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _authService.logout();
    } catch (_) {
      // Logout lokal tetap harus dilanjutkan jika API gagal.
    }

    if (Get.context == null) return;

    Get.offAll(() => const LoginView());
  }

  String errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        final message = data['message'];

        if (message != null) {
          return message.toString();
        }

        final errors = data['errors'];

        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;

          if (first is List && first.isNotEmpty) {
            return first.first.toString();
          }
        }
      }

      if (error.response == null) {
        return 'Tidak dapat terhubung ke server.';
      }
    }

    return 'Terjadi kesalahan. Silakan coba lagi.';
  }

  void showMessage(String message, {bool isError = false}) {
    if (Get.context == null) return;

    Get.snackbar(
      isError ? 'Perhatian' : 'Informasi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  String get displayName {
    final name = user['name']?.toString().trim() ?? '';
    return name.isEmpty ? 'Pengguna eLingk' : name;
  }

  String get phone => user['phone']?.toString() ?? '';

  String get email => user['email']?.toString() ?? '';

  String get initials {
    final name = displayName.trim();

    if (name.isEmpty) return 'U';

    final parts = name.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
