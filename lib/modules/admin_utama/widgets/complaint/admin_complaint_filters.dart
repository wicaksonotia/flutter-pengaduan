import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_complaints_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminComplaintFilters extends StatelessWidget {
  const AdminComplaintFilters({required this.controller, super.key});

  final AdminComplaintsController controller;

  static const Map<String, String> statusLabels = {
    '': 'Semua status',
    'diajukan': 'Diajukan',
    'ditugaskan': 'Ditugaskan',
    'diproses': 'Diproses',
    'menunggu_verifikasi': 'Menunggu verifikasi',
    'menunggu_persetujuan': 'Menunggu persetujuan',
    'selesai': 'Selesai',
    'ditolak': 'Ditolak',
    'ditutup': 'Ditutup',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter pengaduan',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: controller.selectedStatus.value,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              items: statusLabels.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                controller.applyFilter(status: value);
              },
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.blue,
              title: const Text(
                'Belum didelegasikan ke unit',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
              value: controller.belumDidelegasikan.value,
              onChanged: (value) {
                controller.applyFilter(hanyaBelumDidelegasikan: value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ],
      ),
    );
  }
}
