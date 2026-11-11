import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_utama/controllers/admin_utama_units_controller.dart';

class UnitsFilter extends StatelessWidget {
  const UnitsFilter({super.key, required this.controller});

  final AdminUtamaUnitsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedValue = controller.selectedAktif.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 15, color: AppColors.navy),
              const SizedBox(width: 7),
              const Text(
                'Filter Status',
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (selectedValue != null)
                GestureDetector(
                  onTap: () {
                    controller.applyFilter(clearAktif: true);
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.025),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<bool?>(
                value: selectedValue,
                isExpanded: true,
                borderRadius: BorderRadius.circular(13),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.navy,
                  size: 22,
                ),
                hint: const Text('Pilih status'),
                items: [
                  _buildItem(
                    value: null,
                    label: 'Semua Status',
                    icon: Icons.layers_outlined,
                    color: AppColors.navy,
                  ),
                  _buildItem(
                    value: true,
                    label: 'Aktif',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.blue,
                  ),
                  _buildItem(
                    value: false,
                    label: 'Nonaktif',
                    icon: Icons.cancel_outlined,
                    color: AppColors.danger,
                  ),
                ],
                onChanged: (value) {
                  controller.applyFilter(
                    aktif: value,
                    clearAktif: value == null,
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  DropdownMenuItem<bool?> _buildItem({
    required bool? value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return DropdownMenuItem<bool?>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
