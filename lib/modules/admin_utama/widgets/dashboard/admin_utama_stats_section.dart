import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_utama_controller.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUtamaStatsSection extends StatelessWidget {
  final AdminUtamaController controller;

  const AdminUtamaStatsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Pengaduan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        Obx(
          () => GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              AdminStatCard(
                title: 'Total Pengaduan',
                value: controller.totalPengaduan.value,
                icon: Icons.inbox_rounded,
                color: AppColors.blue,
              ),
              AdminStatCard(
                title: 'Pengaduan Baru',
                value: controller.pengaduanBaru.value,
                icon: Icons.fiber_new_rounded,
                color: AppColors.warning,
              ),
              AdminStatCard(
                title: 'Sedang Diproses',
                value: controller.pengaduanDiproses.value,
                icon: Icons.sync_rounded,
                color: AppColors.blue,
              ),
              AdminStatCard(
                title: 'Menunggu Persetujuan',
                value: controller.menungguPersetujuan.value,
                icon: Icons.fact_check_outlined,
                color: AppColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
