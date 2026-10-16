import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elingk/modules/auth/auth_service.dart';
import 'package:elingk/modules/auth/login_view.dart';

class AdminProfileController extends GetxController {
  final isLoggingOut = false.obs;

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    try {
      isLoggingOut.value = true;
      await AuthService().logout();
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
}
