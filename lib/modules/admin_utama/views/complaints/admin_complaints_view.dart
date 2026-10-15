import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/widgets/app_empty_state.dart';
import 'package:elingk/app/widgets/app_header.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_complaints_controller.dart';
import 'package:elingk/modules/admin_utama/views/complaints/admin_complaint_detail_view.dart';
import 'package:elingk/modules/admin_utama/widgets/complaint/admin_complaint_card.dart';
import 'package:elingk/modules/admin_utama/widgets/complaint/admin_complaint_error.dart';
import 'package:elingk/modules/admin_utama/widgets/complaint/admin_complaint_filters.dart';
import 'package:elingk/modules/admin_utama/widgets/complaint/admin_complaint_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminComplaintsView extends StatefulWidget {
  const AdminComplaintsView({super.key});

  @override
  State<AdminComplaintsView> createState() => _AdminComplaintsViewState();
}

class _AdminComplaintsViewState extends State<AdminComplaintsView> {
  late final AdminComplaintsController controller;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<AdminComplaintsController>()) {
      Get.put(AdminComplaintsController());
    }

    controller = Get.find<AdminComplaintsController>();
  }

  @override
  void dispose() {
    if (Get.isRegistered<AdminComplaintsController>()) {
      Get.delete<AdminComplaintsController>();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Pengelolaan Pengaduan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.complaints.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.blue),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.complaints.isEmpty) {
          return AdminComplaintError(
            message: controller.errorMessage.value,
            onRetry: controller.refresh,
          );
        }

        return RefreshIndicator(
          color: AppColors.blue,
          onRefresh: controller.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              AdminComplaintSummary(controller: controller),
              const SizedBox(height: 16),

              AdminComplaintFilters(controller: controller),
              const SizedBox(height: 20),

              AppHeader(
                title: 'Daftar Pengaduan',
                subtitle:
                    '${controller.complaints.length} pengaduan ditampilkan',
                badgeText: '${controller.total.value} total',
                badgeColor: AppColors.blue,
                badgeIcon: Icons.inbox_outlined,
              ),
              const SizedBox(height: 12),

              if (controller.complaints.isEmpty)
                const AppEmptyState(
                  title: 'Belum ada pengaduan',
                  description: 'Coba ubah filter pengaduan.',
                  icon: Icons.inbox_outlined,
                )
              else
                ...controller.complaints.map((complaint) {
                  return AdminComplaintCard(
                    complaint: complaint,
                    onTap: () async {
                      final id = int.tryParse('${complaint['id']}');

                      if (id == null) {
                        Get.snackbar(
                          'Error',
                          'ID pengaduan tidak valid.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      await Get.to(
                        () => AdminComplaintDetailView(complaintId: id),
                      );

                      if (!mounted) return;

                      await controller.refresh();
                    },
                  );
                }),

              if (controller.isLoadingMore.value)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.blue),
                  ),
                ),

              if (!controller.isLoadingMore.value &&
                  controller.currentPage.value < controller.lastPage.value)
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  child: OutlinedButton(
                    onPressed: controller.loadMore,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.blue,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Text('Muat lebih banyak'),
                  ),
                ),

              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
