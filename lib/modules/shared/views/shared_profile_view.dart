import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/controllers/shared_profile_controller.dart';

class SharedProfileView extends StatefulWidget {
  final String roleName;
  final String description;
  final IconData icon;

  const SharedProfileView({
    super.key,
    required this.roleName,
    this.description = 'Pengelola layanan eLingk',
    this.icon = Icons.admin_panel_settings_rounded,
  });

  @override
  State<SharedProfileView> createState() => _SharedProfileViewState();
}

class _SharedProfileViewState extends State<SharedProfileView> {
  late final SharedProfileController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<SharedProfileController>()
        ? Get.find<SharedProfileController>()
        : Get.put(SharedProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil Admin'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 46),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.roleName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Akun',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.verified_user_outlined,
                color: AppColors.navy,
              ),
              title: const Text(
                'Hak Akses',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                widget.roleName,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Obx(
            () => SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: controller.isLoggingOut.value
                    ? null
                    : controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.navy.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: controller.isLoggingOut.value
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.logout_rounded),
                label: Text(
                  controller.isLoggingOut.value
                      ? 'Sedang keluar...'
                      : 'Keluar dari Akun',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
