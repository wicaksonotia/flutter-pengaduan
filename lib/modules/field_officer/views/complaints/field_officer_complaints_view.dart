import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/field_officer/bindings/field_officer_binding.dart';
import 'package:elingk/modules/field_officer/controllers/field_officer_assignments_controller.dart';
import 'package:elingk/modules/field_officer/widgets/complaints/field_officer_assignment_tile.dart';
import 'package:elingk/modules/field_officer/widgets/complaints/field_officer_empty_complaints.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_error.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_loading.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_status_filter.dart';
import 'package:elingk/modules/shared/widgets/complaint/shared_complaint_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldOfficerComplaintsView extends StatefulWidget {
  const FieldOfficerComplaintsView({super.key});

  @override
  State<FieldOfficerComplaintsView> createState() =>
      _FieldOfficerComplaintsViewState();
}

class _FieldOfficerComplaintsViewState
    extends State<FieldOfficerComplaintsView> {
  late final FieldOfficerAssignmentsController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    FieldOfficerBinding().dependencies();
    controller = Get.find<FieldOfficerAssignmentsController>();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Pengaduan Saya',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.assignments.isEmpty) {
          return const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: SharedComplaintLoading(),
          );
        }

        if (controller.error.value != null && controller.assignments.isEmpty) {
          return SharedComplaintError(
            message: controller.error.value!,
            onRetry: controller.loadAssignments,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAssignments,
          color: AppColors.blue,
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18),
            children: [
              SharedComplaintSummary(
                title: 'Total Tugas',
                subtitle: 'Seluruh tugas pengaduan yang diberikan',
                total: controller.summary['total'] ?? 0,
              ),
              const SizedBox(height: 18),

              _buildStatusSummary(),

              const SizedBox(height: 22),

              SharedComplaintStatusFilter(
                selectedStatus: controller.selectedStatus.value,
                statusOptions: const {
                  '': 'Semua',
                  // 'ditugaskan': 'Ditugaskan',
                  'diproses': 'Sedang Diproses',
                  'menunggu_pemeriksaan_unit': 'Menunggu Pemeriksaan',
                },
                onChanged: (status) {
                  controller.applyFilter(status: status);
                },
              ),

              const SizedBox(height: 18),

              if (controller.assignments.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: FieldOfficerEmptyComplaints(),
                )
              else
                ...controller.assignments.map(
                  (assignment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FieldOfficerAssignmentTile(assignment: assignment),
                  ),
                ),

              if (controller.isLoadingMore.value)
                const SharedComplaintLoading(itemCount: 1, showSummary: false),

              if (!controller.hasMore && controller.assignments.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 16),
                  child: Center(
                    child: Text(
                      'Semua tugas sudah ditampilkan',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusSummary() {
    return Row(
      children: [
        // Expanded(
        //   child: _StatusSummaryCard(
        //     title: 'Ditugaskan',
        //     total: controller.summary['ditugaskan'] ?? 0,
        //     icon: Icons.assignment_outlined,
        //   ),
        // ),
        // const SizedBox(width: 10),
        Expanded(
          child: _StatusSummaryCard(
            title: 'Diproses',
            total: controller.summary['diproses'] ?? 0,
            icon: Icons.engineering_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatusSummaryCard(
            title: 'Menunggu',
            total: controller.summary['menunggu_pemeriksaan_unit'] ?? 0,
            icon: Icons.fact_check_outlined,
          ),
        ),
      ],
    );
  }
}

class _StatusSummaryCard extends StatelessWidget {
  final String title;
  final int total;
  final IconData icon;

  const _StatusSummaryCard({
    required this.title,
    required this.total,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.blue, size: 21),
          const SizedBox(height: 10),
          Text(
            '$total',
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
