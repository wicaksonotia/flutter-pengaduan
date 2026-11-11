import 'package:dio/dio.dart';
import 'package:sigapkawan/modules/auth/auth_service.dart';
import 'package:sigapkawan/modules/auth/login_view.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  ProfileController({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  final isLoading = true.obs;
  final isSaving = false.obs;
  final isLoggingOut = false.obs;

  final user = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (isSaving.value || isLoggingOut.value) return;

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
    if (isSaving.value || isLoggingOut.value) return false;

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

  Future<void> logout() async {
    if (isLoggingOut.value || isSaving.value) return;

    try {
      isLoggingOut.value = true;

      await _authService.logout();

      Get.offAll(() => const LoginView());
    } catch (_) {
      showMessage(
        'Tidak dapat keluar dari akun. Silakan coba lagi.',
        isError: true,
        title: 'Logout gagal',
      );
    } finally {
      isLoggingOut.value = false;
    }
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

  void showMessage(String message, {bool isError = false, String? title}) {
    if (Get.context == null) return;

    Get.snackbar(
      title ?? (isError ? 'Perhatian' : 'Informasi'),
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  String get displayName {
    final name = user['name']?.toString().trim() ?? '';
    return name.isEmpty ? 'Pengguna SigapKawan' : name;
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
