import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/shared/controllers/shared_profile_controller.dart';
import 'package:sapahub/modules/shared/widgets/profile/profile_account_card.dart';
import 'package:sapahub/modules/shared/widgets/profile/profile_footer.dart';
import 'package:sapahub/modules/shared/widgets/profile/profile_header.dart';
import 'package:sapahub/modules/shared/widgets/profile/profile_logout_button.dart';
import 'package:sapahub/modules/shared/widgets/profile/profile_logout_dialog.dart';
import 'package:sapahub/modules/shared/widgets/profile/profile_section_title.dart';
import 'package:sapahub/modules/shared/widgets/profile/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedProfileView extends GetView<SharedProfileController> {
  const SharedProfileView({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await ProfileLogoutDialog.show(context);

    if (confirmed == true) {
      await controller.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshProfile,
        child: Obx(() {
          final profile = controller.profile.value;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
            children: [
              if (profile == null) ...[
                if (controller.isLoading.value)
                  const ProfileShimmer()
                else
                  _buildErrorState(),
              ] else ...[
                ProfileHeader(
                  name: profile.name,
                  description: profile.roleDescription,
                  avatar: profile.avatar,
                ),
                const SizedBox(height: 28),

                const ProfileSectionTitle(
                  title: 'Informasi Akun',
                  subtitle: 'Informasi peran dan akses aplikasi.',
                ),
                const SizedBox(height: 13),

                ProfileAccountCard(profile: profile),
                const SizedBox(height: 28),

                ProfileLogoutButton(
                  isLoading: controller.isLoggingOut.value,
                  onPressed: () => _confirmLogout(context),
                ),
                const SizedBox(height: 24),

                const Center(child: ProfileFooter()),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          const Icon(
            Icons.account_circle_outlined,
            size: 55,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          const Text(
            'Profil belum dapat ditampilkan',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage.value.isEmpty
                ? 'Silakan coba kembali.'
                : controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: controller.fetchProfile,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
