import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/network/api_client.dart';
import 'complaint_helpers.dart';
import 'complaint_service.dart';

class ComplaintDetailView extends StatefulWidget {
  const ComplaintDetailView({super.key, required this.complaintId});

  final int complaintId;

  @override
  State<ComplaintDetailView> createState() => _ComplaintDetailViewState();
}

class _ComplaintDetailViewState extends State<ComplaintDetailView> {
  final ComplaintService _service = ComplaintService();
  final Dio _dio = ApiClient.dio;

  Map<String, dynamic>? _complaint;
  bool _loading = true;
  String? _error;

  static const Color _navy = Color(0xFF142B4A);
  static const Color _blue = Color(0xFF2878F0);
  static const Color _background = Color(0xFFF4F7FC);

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _service.getComplaintDetail(widget.complaintId);

      final raw = response['data'];

      if (raw is! Map) {
        throw Exception('Data detail pengaduan tidak ditemukan.');
      }

      if (!mounted) return;

      setState(() {
        _complaint = Map<String, dynamic>.from(raw);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = _errorMessage(e);
        _loading = false;
      });
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      if (error.response?.statusCode == 404) {
        return 'Pengaduan tidak ditemukan atau tidak dapat diakses.';
      }

      return 'Tidak dapat mengambil detail pengaduan. Periksa koneksi.';
    }

    return 'Detail pengaduan gagal dimuat. Silakan coba lagi.';
  }

  String _text(dynamic value, {String fallback = '-'}) {
    if (value == null || value.toString().trim().isEmpty) {
      return fallback;
    }

    return value.toString();
  }

  List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _imageUrl(dynamic value) {
    final path = (value ?? '').toString().trim();
    if (path.isEmpty) return '';

    final uri = Uri.tryParse(path);
    if (uri != null && uri.hasScheme) return path;

    return Uri.parse(_dio.options.baseUrl).resolve(path).toString();
  }

  void _showImage(String url) {
    if (url.isEmpty) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            InteractiveViewer(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 250,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(dialogContext),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(dynamic latitude, dynamic longitude) async {
    final lat = double.tryParse('$latitude');
    final lng = double.tryParse('$longitude');

    if (lat == null ||
        lng == null ||
        lat < -90 ||
        lat > 90 ||
        lng < -180 ||
        lng > 180) {
      _showMapMessage('Koordinat lokasi tidak valid.');
      return;
    }

    // Tautan langsung ke koordinat kejadian.
    final googleMapsUri = Uri.parse('https://maps.google.com/?q=$lat,$lng');

    try {
      // Coba buka Google Maps atau aplikasi penangan tautan.
      final opened = await launchUrl(
        googleMapsUri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        _showMapMessage(
          'Tautan tidak dapat dibuka. Periksa browser dan koneksi internet.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showMapMessage('Gagal membuka Google Maps: $e');
    }
  }

  void _showMapMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Pengaduan',
          style: TextStyle(
            color: _navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : _error != null
          ? _buildError()
          : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFF94A3B8),
              size: 58,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B), height: 1.5),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _loadDetail,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final data = _complaint!;

    final photos = _mapList(data['photos']);
    final histories = _mapList(
      data['status_histories'] ?? data['statusHistories'],
    );
    final responses = _mapList(data['responses']);

    final status = data['status'];
    final statusColor = ComplaintHelpers.statusColor(status);
    final submittedAt = data['diajukan_pada'] ?? data['created_at'];

    final latitude = data['latitude'];
    final longitude = data['longitude'];

    final category = data['category'];
    final unit = data['unit'];

    return RefreshIndicator(
      onRefresh: _loadDetail,
      color: _blue,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(21),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF142B4A), Color(0xFF285A91)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NOMOR PENGADUAN',
                  style: TextStyle(
                    color: Color(0xFFBFD9F5),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _text(data['nomor_pengaduan']),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ComplaintHelpers.statusLabel(status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFFBFD9F5),
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Diajukan ${ComplaintHelpers.formatDateTime(submittedAt)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _section(
            title: 'Informasi Pengaduan',
            icon: Icons.description_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Judul Laporan',
                  style: TextStyle(color: Color(0xFF7B8798), fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  _text(data['judul'], fallback: 'Tanpa judul'),
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Isi Pengaduan',
                  style: TextStyle(color: Color(0xFF7B8798), fontSize: 12),
                ),
                const SizedBox(height: 7),
                Text(
                  _text(
                    data['isi_pengaduan'],
                    fallback: 'Isi pengaduan belum tersedia.',
                  ),
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
                if (category is Map &&
                    _text(category['nama'], fallback: '').isNotEmpty) ...[
                  const SizedBox(height: 18),
                  _detailRow(
                    Icons.category_outlined,
                    'Kategori',
                    _text(category['nama']),
                  ),
                ],
                if (unit is Map &&
                    _text(unit['nama'], fallback: '').isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _detailRow(
                    Icons.account_balance_outlined,
                    'Unit penanganan',
                    _text(unit['nama']),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 15),

          _section(
            title: 'Lokasi Kejadian',
            icon: Icons.location_on_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _text(data['alamat'], fallback: 'Alamat belum tersedia.'),
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 16),

                // Peta interaktif dan pin lokasi pengaduan.
                _buildLocationMap(latitude, longitude),

                const SizedBox(height: 16),
                _coordinateRow('Latitude', latitude),
                const SizedBox(height: 10),
                _coordinateRow('Longitude', longitude),
                const SizedBox(height: 15),

                if (latitude != null && longitude != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openGoogleMaps(latitude, longitude),
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Buka Lokasi di Google Maps'),
                    ),
                  ),
              ],
            ),
          ),

          if (photos.isNotEmpty) ...[
            const SizedBox(height: 15),
            _section(
              title: 'Foto Pengaduan',
              icon: Icons.photo_library_outlined,
              child: SizedBox(
                height: 112,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 11),
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    final url = _imageUrl(photo['url'] ?? photo['path']);

                    return GestureDetector(
                      onTap: () => _showImage(url),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Container(
                          width: 125,
                          color: const Color(0xFFE8EDF5),
                          child: url.isEmpty
                              ? const Icon(
                                  Icons.broken_image_outlined,
                                  color: Color(0xFF94A3B8),
                                )
                              : Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.broken_image_outlined,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 15),
          _section(
            title: 'Riwayat Pengaduan',
            icon: Icons.timeline_rounded,
            child: histories.isEmpty
                ? const Text(
                    'Riwayat perkembangan belum tersedia.',
                    style: TextStyle(
                      color: Color(0xFF7B8798),
                      fontSize: 12,
                      height: 1.6,
                    ),
                  )
                : Column(
                    children: histories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final history = entry.value;

                      final historyStatus =
                          history['status_baru'] ??
                          history['status'] ??
                          history['status_tujuan'];

                      final historyDate =
                          history['created_at'] ?? history['tanggal'];

                      final note =
                          history['catatan'] ??
                          history['keterangan'] ??
                          history['deskripsi'];

                      return _historyItem(
                        status: historyStatus,
                        date: historyDate,
                        note: note,
                        isLast: index == histories.length - 1,
                      );
                    }).toList(),
                  ),
          ),
          if (responses.isNotEmpty) ...[
            const SizedBox(height: 15),
            _section(
              title: 'Tanggapan Petugas',
              icon: Icons.chat_bubble_outline_rounded,
              child: Column(
                children: responses.map((response) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _text(
                            response['isi'] ??
                                response['pesan'] ??
                                response['isi_tanggapan'],
                          ),
                          style: const TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 12,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ComplaintHelpers.formatDateTime(
                            response['created_at'],
                          ),
                          style: const TextStyle(
                            color: Color(0xFF7B8798),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: _blue.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: _blue, size: 19),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: const Color(0xFF8291A5)),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF7B8798), fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _coordinateRow(String label, dynamic value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF7B8798), fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          ComplaintHelpers.formatCoordinate(value),
          style: const TextStyle(
            color: _navy,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _historyItem({
    required dynamic status,
    required dynamic date,
    required dynamic note,
    required bool isLast,
  }) {
    final color = ComplaintHelpers.statusColor(status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.18),
                      width: 4,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: const Color(0xFFE2E8F0)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ComplaintHelpers.statusLabel(status),
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ComplaintHelpers.formatDateTime(date),
                    style: const TextStyle(
                      color: Color(0xFF7B8798),
                      fontSize: 11,
                    ),
                  ),
                  if (note != null && note.toString().trim().isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      note.toString(),
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMap(dynamic latitude, dynamic longitude) {
    final lat = double.tryParse('$latitude');
    final lng = double.tryParse('$longitude');

    if (lat == null ||
        lng == null ||
        lat < -90 ||
        lat > 90 ||
        lng < -180 ||
        lng > 180) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text(
          'Koordinat lokasi belum tersedia.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    final point = LatLng(lat, lng);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: 230,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 16,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'id.go.elingk',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.location_pin,
                    size: 46,
                    color: Color(0xFFE5484D),
                  ),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
