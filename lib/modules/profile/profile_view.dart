import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/edit_profile_sheet.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_information_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

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
                    onEdit: () => _editProfile(context, controller),
                  ),

                const SizedBox(height: 22),

                ProfileInformationCard(
                  name: controller.displayName,
                  phone: controller.phone,
                  email: controller.email,
                  isLoading: isLoading,
                ),

                const SizedBox(height: 22),

                OutlinedButton.icon(
                  onPressed: () => controller.confirmLogout(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: BorderSide(
                      color: AppColors.danger.withValues(alpha: 0.35),
                    ),
                    backgroundColor: AppColors.surface,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    'Keluar dari Akun',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),

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

  Future<void> _editProfile(
    BuildContext context,
    ProfileController controller,
  ) async {
    final result = await EditProfileSheet.show(
      context,
      name: controller.user['name']?.toString() ?? '',
      email: controller.email,
    );

    if (result == null) return;

    await controller.saveProfile(
      name: result['name']!,
      email: result['email']!,
    );
  }
}
