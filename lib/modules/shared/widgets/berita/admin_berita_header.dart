import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/admin_utama/controllers/admin_utama_berita_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBeritaHeader extends StatelessWidget {
  const AdminBeritaHeader({super.key, required this.controller});

  final AdminUtamaBeritaController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.navy, AppColors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Obx(() {
          // Observable dibaca langsung dalam cakupan Obx.
          final total = controller.total.value;
          final displayed = controller.articles.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Publikasi Informasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kelola berita dan pengumuman seluruh instansi.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _StatisticItem(
                    label: 'Total Artikel',
                    value: total.toString(),
                    icon: Icons.article_outlined,
                  ),
                  const SizedBox(width: 24),
                  _StatisticItem(
                    label: 'Ditampilkan',
                    value: displayed.toString(),
                    icon: Icons.visibility_outlined,
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _StatisticItem extends StatelessWidget {
  const _StatisticItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 23),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
