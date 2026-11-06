import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sapahub/app/data/models/unit_model.dart';
import 'package:sapahub/app/theme/app_colors.dart';
import 'package:sapahub/modules/admin_utama/controllers/admin_utama_units_controller.dart';
import 'package:sapahub/modules/admin_utama/widgets/units/view/unit_deactivate_dialog.dart';
import 'package:sapahub/modules/admin_utama/widgets/units/view/unit_list_shimmer.dart';
import 'package:sapahub/modules/admin_utama/widgets/units/view/units_filter.dart';
import 'package:sapahub/modules/admin_utama/widgets/units/view/units_list.dart';
import 'package:sapahub/modules/admin_utama/widgets/units/view/units_search_field.dart';

class AdminUtamaUnitsView extends StatefulWidget {
  const AdminUtamaUnitsView({super.key});

  @override
  State<AdminUtamaUnitsView> createState() => _AdminUtamaUnitsViewState();
}

class _AdminUtamaUnitsViewState extends State<AdminUtamaUnitsView> {
  late final AdminUtamaUnitsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AdminUtamaUnitsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Manajemen Unit',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.navy,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUnit,
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Unit'),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.blue,
        backgroundColor: AppColors.surface,
        displacement: 45,
        strokeWidth: 2.5,
        child: Obx(() {
          // Loading pertama
          if (controller.isLoading.value && controller.units.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: const [UnitListShimmer(itemCount: 4)],
            );
          }

          // Error ketika data kosong
          if (controller.errorMessage.value.isNotEmpty &&
              controller.units.isEmpty) {
            return _buildError();
          }

          // Daftar unit
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              UnitsSearchField(controller: controller),
              const SizedBox(height: 12),
              UnitsFilter(controller: controller),
              const SizedBox(height: 20),
              UnitsList(
                controller: controller,
                onDetail: _showUnitDetail,
                onEdit: _showEditUnit,
                onToggleStatus: _confirmToggleStatus,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildError() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 100),
        const Icon(Icons.cloud_off_rounded, color: AppColors.danger, size: 48),
        const SizedBox(height: 12),
        Text(
          controller.errorMessage.value,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.navy, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        ),
      ],
    );
  }

  void _showAddUnit() {
    Get.snackbar(
      'Tambah Unit',
      'Form tambah unit akan segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showEditUnit(UnitModel unit) {
    Get.snackbar(
      'Edit Unit',
      'Form edit unit akan segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showUnitDetail(UnitModel unit) {
    Get.snackbar('Detail Unit', unit.nama, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> _confirmToggleStatus(UnitModel unit) async {
    await UnitStatusDialog.show(unit: unit, controller: controller);
  }
}
