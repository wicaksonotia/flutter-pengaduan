import 'package:elingk/modules/admin_utama/controllers/admin_complaints_controller.dart';
import 'package:elingk/modules/admin_utama/views/complaints/admin_complaint_detail_view.dart';
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

  static const Map<String, String> statusLabels = {
    '': 'Semua status',
    'diajukan': 'Diajukan',
    'ditugaskan': 'Ditugaskan',
    'diproses': 'Diproses',
    'menunggu_verifikasi': 'Menunggu verifikasi',
    'menunggu_persetujuan': 'Menunggu persetujuan',
    'selesai': 'Selesai',
    'ditolak': 'Ditolak',
  };

  String _text(dynamic value, [String fallback = '-']) {
    if (value == null || '$value'.trim().isEmpty) return fallback;
    return '$value';
  }

  String _statusLabel(String status) {
    return statusLabels[status] ?? status.replaceAll('_', ' ');
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'diajukan':
        return Colors.orange;
      case 'ditugaskan':
      case 'diproses':
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Pengelolaan Pengaduan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172B4D),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.complaints.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.complaints.isEmpty) {
          return _buildError();
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummary(),
              const SizedBox(height: 16),
              _buildFilters(),
              const SizedBox(height: 16),
              if (controller.complaints.isEmpty)
                _buildEmpty()
              else
                ...controller.complaints.map(_buildComplaintCard),
              if (controller.isLoadingMore.value)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (!controller.isLoadingMore.value &&
                  controller.currentPage.value < controller.lastPage.value)
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  child: OutlinedButton(
                    onPressed: controller.loadMore,
                    child: const Text('Muat lebih banyak'),
                  ),
                ),
              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF172B4D), Color(0xFF1769AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pengaduan',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 6),
                Text(
                  'Data pengaduan masyarakat',
                  style: TextStyle(
                    color: Colors.white,
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
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter pengaduan',
            style: TextStyle(fontWeight: FontWeight.w700),
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
                return DropdownMenuItem(
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
              title: const Text(
                'Belum didelegasikan ke unit',
                style: TextStyle(fontSize: 14),
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

  Widget _buildComplaintCard(Map<String, dynamic> complaint) {
    final status = _text(complaint['status'], 'diajukan');
    final user = complaint['user'] is Map
        ? Map<String, dynamic>.from(complaint['user'] as Map)
        : <String, dynamic>{};
    final category = complaint['category'] is Map
        ? Map<String, dynamic>.from(complaint['category'] as Map)
        : <String, dynamic>{};
    final unit = complaint['unit'] is Map
        ? Map<String, dynamic>.from(complaint['unit'] as Map)
        : <String, dynamic>{};

    final nomor = _text(
      complaint['nomor_pengaduan'] ?? complaint['nomor'],
      'Pengaduan #${complaint['id'] ?? '-'}',
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final id = int.tryParse('${complaint['id']}');

          if (id == null) {
            Get.snackbar(
              'Error',
              'ID pengaduan tidak valid.',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          Get.to(() => AdminComplaintDetailView(complaintId: id));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      nomor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel(status),
                      style: TextStyle(
                        color: _statusColor(status),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _text(
                  complaint['judul'] ?? complaint['title'],
                  'Pengaduan masyarakat',
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _text(complaint['isi_pengaduan'] ?? 'Tidak ada deskripsi'),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF65738B), height: 1.4),
              ),
              const Divider(height: 24),
              _infoRow(
                Icons.person_outline,
                _text(user['name'], 'Pelapor tidak diketahui'),
              ),
              const SizedBox(height: 7),
              _infoRow(
                Icons.category_outlined,
                _text(category['nama'], 'Belum ada kategori'),
              ),
              const SizedBox(height: 7),
              _infoRow(
                Icons.account_tree_outlined,
                _text(unit['nama'], 'Belum didelegasikan'),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lihat detail',
                    style: TextStyle(
                      color: Color(0xFF1769AA),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 16, color: Color(0xFF1769AA)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 17, color: const Color(0xFF7A879B)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Color(0xFF65738B)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 54, color: Color(0xFF9AA7B8)),
          SizedBox(height: 12),
          Text(
            'Belum ada pengaduan',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6),
          Text(
            'Coba ubah filter pengaduan.',
            style: TextStyle(color: Color(0xFF65738B)),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.cloud_off_outlined, size: 54),
        const SizedBox(height: 12),
        const Center(child: Text('Gagal mengambil pengaduan')),
        const SizedBox(height: 8),
        Center(child: Text(controller.errorMessage.value)),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: controller.refresh,
            child: const Text('Coba lagi'),
          ),
        ),
      ],
    );
  }
}
