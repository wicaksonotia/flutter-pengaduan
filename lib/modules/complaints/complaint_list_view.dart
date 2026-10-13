import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'complaint_detail_view.dart';
import 'complaint_form_view.dart';
import 'complaint_service.dart';
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
  final ComplaintService _service = ComplaintService();

  List<Map<String, dynamic>> _complaints = [];
  bool _loading = true;
  String? _error;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final response = await _service.getComplaints();
      final pagination = response['data'];
      final rawData = pagination is Map ? pagination['data'] : null;

      final items = rawData is List
          ? rawData
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
          : <Map<String, dynamic>>[];

      final total = pagination is Map
          ? int.tryParse('${pagination['total'] ?? items.length}') ??
                items.length
          : items.length;

      if (!mounted) return;

      setState(() {
        _complaints = items;
        _total = total;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'Gagal memuat pengaduan. Periksa koneksi lalu coba lagi.';
        _loading = false;
      });
    }
  }

  Future<void> _openCreateForm() async {
    final result = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const ComplaintFormView()));

    if (!mounted) return;

    if (result == true) {
      await _loadComplaints();
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
      body: _buildBody(),
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
    if (_loading && _complaints.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blue),
      );
    }

    if (_error != null && _complaints.isEmpty) {
      return ComplaintListStateMessage(
        icon: Icons.cloud_off_rounded,
        title: 'Belum bisa memuat data',
        message: _error!,
        buttonText: 'Coba Lagi',
        onPressed: _loadComplaints,
      );
    }

    if (_complaints.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadComplaints,
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
      onRefresh: _loadComplaints,
      color: AppColors.blue,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          ComplaintListHeader(total: _total),
          const SizedBox(height: 25),
          ComplaintListSectionHeading(displayed: _complaints.length),
          const SizedBox(height: 13),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
          ],
          ..._complaints.map(
            (item) =>
                ComplaintListCard(item: item, onTap: () => _openDetail(item)),
          ),
        ],
      ),
    );
  }
}
