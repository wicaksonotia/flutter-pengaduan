import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileInformationCard extends StatelessWidget {
  const ProfileInformationCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.isLoading,
  });

  final String name;
  final String phone;
  final String email;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Akun',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(22),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              ),
            )
          else ...[
            _InfoTile(
              icon: Icons.person_outline_rounded,
              label: 'Nama lengkap',
              value: name,
            ),
            const Divider(height: 1, color: AppColors.divider),
            _InfoTile(
              icon: Icons.phone_outlined,
              label: 'Nomor HP',
              value: phone,
            ),
            const Divider(height: 1, color: AppColors.divider),
            _InfoTile(icon: Icons.email_outlined, label: 'Email', value: email),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.blueLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.iconPrimary, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value.isEmpty ? 'Belum diisi' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
