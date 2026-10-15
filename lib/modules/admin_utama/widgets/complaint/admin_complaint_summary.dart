import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_complaints_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminComplaintSummary extends StatelessWidget {
  const AdminComplaintSummary({required this.controller, super.key});

  final AdminComplaintsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pengaduan',
                  style: TextStyle(color: AppColors.white, fontSize: 13),
                ),
                SizedBox(height: 6),
                Text(
                  'Data pengaduan masyarakat',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Text(
              '${controller.total.value}',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
