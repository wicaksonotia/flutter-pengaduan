import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapahub/app/data/models/unit_model.dart';
import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/app/widgets/app_empty_state.dart';
import 'package:sapahub/app/widgets/app_header.dart';
import 'package:sapahub/modules/admin_utama/controllers/admin_utama_units_controller.dart';
import 'package:sapahub/modules/admin_utama/widgets/units/view/unit_card.dart';
import 'package:sapahub/modules/admin_utama/widgets/units/view/unit_list_shimmer.dart';

class UnitsList extends StatelessWidget {
  const UnitsList({
    super.key,
    required this.controller,
    required this.onDetail,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final AdminUtamaUnitsController controller;
  final ValueChanged<UnitModel> onDetail;
  final ValueChanged<UnitModel> onEdit;
  final ValueChanged<UnitModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => AppHeader(
            title: 'Daftar Unit',
            subtitle: '${controller.units.length} unit ditampilkan',
            badgeText: '${controller.total.value} total',
            badgeColor: AppColors.blue,
            badgeIcon: Icons.account_tree_outlined,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.isLoading.value && controller.units.isEmpty) {
            return const UnitListShimmer(itemCount: 4);
          }

          if (controller.units.isEmpty) {
            return const AppEmptyState(
              title: 'Belum ada unit',
              description:
                  'Belum ada unit yang sesuai dengan pencarian atau filter.',
              icon: Icons.account_tree_outlined,
            );
          }

          return Column(
            children: [
              ...controller.units.map(
                (unit) => Padding(
                  key: ValueKey(unit.id),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UnitCard(
                    unit: unit,
                    onTap: () => onDetail(unit),
                    onEdit: () => onEdit(unit),
                    onToggleStatus: () => onToggleStatus(unit),
                  ),
                ),
              ),
              if (controller.isLoadingMore.value)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: UnitListShimmer(itemCount: 2),
                ),
              if (!controller.isLoadingMore.value &&
                  controller.currentPage.value < controller.lastPage.value)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: OutlinedButton.icon(
                    onPressed: controller.loadMore,
                    icon: const Icon(Icons.expand_more_rounded),
                    label: const Text('Muat Lebih Banyak'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.blue,
                      side: BorderSide(
                        color: AppColors.blue.withValues(alpha: 0.3),
                      ),
                      backgroundColor: AppColors.blue.withValues(alpha: 0.04),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
        Obx(() {
          if (controller.errorMessage.value.isEmpty ||
              controller.units.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: AppColors.danger),
            ),
          );
        }),
      ],
    );
  }
}
