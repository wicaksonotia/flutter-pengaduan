import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/masyarakat/bindings/profile_binding.dart';
import 'package:sigapkawan/modules/masyarakat/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/edit_profile_sheet.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_information_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();

    ProfileBinding().dependencies();
    controller = Get.find<ProfileController>();
  }

  Future<void> _confirmLogout() async {
    if (controller.isSaving.value || controller.isLoggingOut.value) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.danger,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Keluar dari Akun?',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Apakah kamu yakin ingin keluar? '
                  'Kamu perlu login kembali untuk mengakses layanan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.6,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Ya, Keluar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await controller.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.blue,
          backgroundColor: AppColors.surface,
          onRefresh: controller.loadProfile,
          child: Obx(() {
            final isLoading = controller.isLoading.value;
            final isSaving = controller.isSaving.value;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
              children: [
                const Text(
                  'Profil Saya',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Informasi akun dan pengaturan profilmu.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 25),

                if (isLoading)
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  )
                else
                  ProfileHeaderCard(
                    name: controller.displayName,
                    phone: controller.phone,
                    initials: controller.initials,
                    isSaving: isSaving,
                    onEdit: () => _editProfile(context),
                  ),

                const SizedBox(height: 22),

                ProfileInformationCard(
                  name: controller.displayName,
                  phone: controller.phone,
                  email: controller.email,
                  isLoading: isLoading,
                ),

                const SizedBox(height: 22),

                Obx(() {
                  final isLoggingOut = controller.isLoggingOut.value;
                  final isBusy = isLoggingOut || controller.isSaving.value;

                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: isBusy ? null : _confirmLogout,
                      icon: isLoggingOut
                          ? const SizedBox(
                              width: 19,
                              height: 19,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.danger,
                              ),
                            )
                          : const Icon(Icons.logout_rounded),
                      label: Text(
                        isLoggingOut ? 'Sedang keluar...' : 'Keluar dari Akun',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: BorderSide(
                          color: AppColors.danger.withValues(alpha: 0.45),
                        ),
                        backgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  );
                }),

                if (isSaving)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.blue),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    if (controller.isSaving.value || controller.isLoggingOut.value) return;

    await EditProfileSheet.show(
      context,
      name: controller.user['name']?.toString() ?? '',
      email: controller.email,
      onSave: (name, email) {
        return controller.saveProfile(name: name, email: email);
      },
    );
  }
}
