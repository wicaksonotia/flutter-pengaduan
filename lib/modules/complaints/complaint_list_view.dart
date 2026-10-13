import 'package:flutter/material.dart';

import 'complaint_detail_view.dart';
import 'complaint_helpers.dart';
import 'complaint_service.dart';

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

  static const Color _navy = Color(0xFF142B4A);
  static const Color _blue = Color(0xFF2878F0);
  static const Color _background = Color(0xFFF4F7FC);

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
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Gagal memuat pengaduan. Periksa koneksi lalu coba lagi.';
        _loading = false;
      });
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
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Pengaduan Saya',
          style: TextStyle(
            color: _navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading && _complaints.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _blue));
    }

    if (_error != null && _complaints.isEmpty) {
      return _StateMessage(
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
        color: _blue,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: const [
            SizedBox(height: 100),
            Icon(Icons.assignment_outlined, size: 68, color: Color(0xFF9AAAC0)),
            SizedBox(height: 18),
            Text(
              'Belum Ada Pengaduan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pengaduan yang kamu kirim akan tampil di halaman ini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF7B8798), height: 1.5),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadComplaints,
      color: _blue,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF142B4A), Color(0xFF285A91)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: _navy.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in_outlined,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Riwayat Pengaduan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Pantau perkembangan laporanmu di sini.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$_total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const Text(
                        'Laporan',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Daftar Laporan',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${_complaints.length} ditampilkan',
                style: const TextStyle(color: Color(0xFF7B8798), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 13),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
          ],
          ..._complaints.map(_buildComplaintCard),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> item) {
    final status = item['status'];
    final statusColor = ComplaintHelpers.statusColor(status);
    final number = (item['nomor_pengaduan'] ?? 'Nomor belum tersedia')
        .toString();
    final title = (item['judul'] ?? 'Tanpa judul').toString();
    final address = (item['alamat'] ?? '').toString().trim();
    final date = item['diajukan_pada'] ?? item['created_at'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF142B4A).withValues(alpha: 0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openDetail(item),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        number,
                        style: const TextStyle(
                          color: _blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: status),
                  ],
                ),
                const SizedBox(height: 13),
                Text(
                  title,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
                if (address.isNotEmpty) ...[
                  const SizedBox(height: 13),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF8291A5),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFEDF1F6)),
                const SizedBox(height: 13),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: Color(0xFF8291A5),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        ComplaintHelpers.formatDateTime(date),
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final dynamic status;

  @override
  Widget build(BuildContext context) {
    final color = ComplaintHelpers.statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        ComplaintHelpers.statusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 58, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF142B4A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B), height: 1.5),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onPressed, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
