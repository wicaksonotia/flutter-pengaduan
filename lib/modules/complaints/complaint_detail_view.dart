import 'package:dio/dio.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../core/network/api_client.dart';
import 'complaint_service.dart';
import 'widgets/detail/complaint_detail_header.dart';
import 'widgets/detail/complaint_detail_history.dart';
import 'widgets/detail/complaint_detail_information.dart';
import 'widgets/detail/complaint_detail_location.dart';
import 'widgets/detail/complaint_detail_photos.dart';
import 'widgets/detail/complaint_detail_responses.dart';

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

    if (uri != null && uri.hasScheme) {
      return path;
    }

    return Uri.parse(_dio.options.baseUrl).resolve(path).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Pengaduan',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
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
              color: AppColors.textMuted,
              size: 58,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, height: 1.5),
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

    final submittedAt = data['diajukan_pada'] ?? data['created_at'];

    return RefreshIndicator(
      onRefresh: _loadDetail,
      color: AppColors.blue,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        children: [
          ComplaintDetailHeader(
            nomorPengaduan: data['nomor_pengaduan'],
            status: data['status'],
            submittedAt: submittedAt,
          ),

          const SizedBox(height: 18),

          ComplaintDetailInformation(
            judul: data['judul'],
            isiPengaduan: data['isi_pengaduan'],
            category: data['category'],
            unit: data['unit'],
          ),

          const SizedBox(height: 15),

          ComplaintDetailLocation(
            alamat: data['alamat'],
            latitude: data['latitude'],
            longitude: data['longitude'],
          ),

          if (photos.isNotEmpty) ...[
            const SizedBox(height: 15),
            ComplaintDetailPhotos(photos: photos, resolveImageUrl: _imageUrl),
          ],

          const SizedBox(height: 15),

          ComplaintDetailHistory(histories: histories),

          if (responses.isNotEmpty) ...[
            const SizedBox(height: 15),
            ComplaintDetailResponses(responses: responses),
          ],
        ],
      ),
    );
  }
}
