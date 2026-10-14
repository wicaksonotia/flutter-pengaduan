import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/bindings/complaint_list_binding.dart';
import 'package:elingk/modules/masyarakat/controllers/complaint_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'complaint_detail_view.dart';
import 'complaint_form_view.dart';
import 'widgets/list/complaint_list_card.dart';
import 'widgets/list/complaint_list_header.dart';
import 'widgets/list/complaint_list_section_heading.dart';
import 'widgets/list/complaint_list_state_message.dart';

class ComplaintListView extends StatefulWidget {
  const ComplaintListView({super.key});

  @override
  State<ComplaintListView> createState() => _ComplaintListViewState();
}

class _ComplaintListViewState extends State<ComplaintListView> {
  late final ComplaintListController controller;

  @override
  void initState() {
    super.initState();

    ComplaintListBinding().dependencies();
    controller = Get.find<ComplaintListController>();
  }

  Future<void> _openCreateForm() async {
    final result = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const ComplaintFormView()));

    if (!mounted) return;

    if (result == true) {
      await controller.loadComplaints();
    }
  }

  void _openDetail(Map<String, dynamic> complaint) {
    final id = int.tryParse('${complaint['id'] ?? ''}');

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID pengaduan tidak valid.')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ComplaintDetailView(complaintId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Pengaduan Saya',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Obx(_buildBody),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateForm,
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Buat Pengaduan'),
      ),
    );
  }

  Widget _buildBody() {
    final complaints = controller.complaints;
    final loading = controller.loading.value;
    final error = controller.error.value;
    final total = controller.total.value;

    if (loading && complaints.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blue),
      );
    }

    if (error != null && complaints.isEmpty) {
      return ComplaintListStateMessage(
        icon: Icons.cloud_off_rounded,
        title: 'Belum bisa memuat data',
        message: error,
        buttonText: 'Coba Lagi',
        onPressed: controller.loadComplaints,
      );
    }

    if (complaints.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.loadComplaints,
        color: AppColors.blue,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: const [
            SizedBox(height: 100),
            Icon(
              Icons.assignment_outlined,
              size: 68,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 18),
            Text(
              'Belum Ada Pengaduan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pengaduan yang kamu kirim akan tampil di halaman ini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, height: 1.5),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.loadComplaints,
      color: AppColors.blue,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          ComplaintListHeader(total: total),
          const SizedBox(height: 25),
          ComplaintListSectionHeading(displayed: complaints.length),
          const SizedBox(height: 13),
          if (error != null) ...[
            Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
          ],
          ...complaints.map(
            (item) =>
                ComplaintListCard(item: item, onTap: () => _openDetail(item)),
          ),
        ],
      ),
    );
  }
}
