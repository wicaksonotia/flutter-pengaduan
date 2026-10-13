import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/complaints/complaint_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'complaint_detail_section.dart';

class ComplaintDetailLocation extends StatelessWidget {
  const ComplaintDetailLocation({
    super.key,
    required this.alamat,
    required this.latitude,
    required this.longitude,
  });

  final dynamic alamat;
  final dynamic latitude;
  final dynamic longitude;

  String _text(dynamic value, {String fallback = '-'}) {
    if (value == null || value.toString().trim().isEmpty) {
      return fallback;
    }

    return value.toString();
  }

  LatLng? _validPoint() {
    final lat = double.tryParse('$latitude');
    final lng = double.tryParse('$longitude');

    if (lat == null ||
        lng == null ||
        !lat.isFinite ||
        !lng.isFinite ||
        lat < -90 ||
        lat > 90 ||
        lng < -180 ||
        lng > 180) {
      return null;
    }

    return LatLng(lat, lng);
  }

  Future<void> _openGoogleMaps(BuildContext context) async {
    final point = _validPoint();

    if (point == null) {
      _showMessage(context, 'Koordinat lokasi tidak valid.');
      return;
    }

    final uri = Uri.parse(
      'https://maps.google.com/?q=${point.latitude},${point.longitude}',
    );

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && context.mounted) {
        _showMessage(
          context,
          'Tautan tidak dapat dibuka. Periksa browser dan koneksi internet.',
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      _showMessage(context, 'Gagal membuka Google Maps.');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final point = _validPoint();

    return ComplaintDetailSection(
      title: 'Lokasi Kejadian',
      icon: Icons.location_on_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _text(alamat, fallback: 'Alamat belum tersedia.'),
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 16),
          _buildMap(point),
          const SizedBox(height: 16),
          _coordinateRow('Latitude', latitude),
          const SizedBox(height: 10),
          _coordinateRow('Longitude', longitude),
          const SizedBox(height: 15),
          if (point != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openGoogleMaps(context),
                icon: const Icon(Icons.map_outlined),
                label: const Text('Buka Lokasi di Google Maps'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMap(LatLng? point) {
    if (point == null) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text(
          'Koordinat lokasi belum tersedia.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      );
    }

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
                    color: AppColors.danger,
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

  Widget _coordinateRow(String label, dynamic value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          ComplaintHelpers.formatCoordinate(value),
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
