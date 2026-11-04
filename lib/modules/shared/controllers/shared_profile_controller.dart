import 'package:elingk/modules/auth/auth_service.dart';
import 'package:elingk/modules/auth/login_view.dart';
import 'package:elingk/modules/shared/models/shared_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedProfileController extends GetxController {
  final AuthService _authService = AuthService();

  final isLoading = false.obs;
  final isLoggingOut = false.obs;
  final errorMessage = ''.obs;

  final profile = Rxn<SharedProfileModel>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authService.getMe();

      profile.value = SharedProfileModel.fromResponse(response);
    } catch (e) {
      errorMessage.value = _messageFromError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    try {
      isLoggingOut.value = true;

      await _authService.logout();

      Get.offAll(() => const LoginView());
    } catch (_) {
      Get.snackbar(
        'Logout gagal',
        'Tidak dapat keluar dari akun. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  String _messageFromError(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return 'Terjadi kesalahan saat mengambil profil pengguna.';
  }
}
