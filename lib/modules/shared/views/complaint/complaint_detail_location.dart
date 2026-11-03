import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/views/complaints/complaint_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'expandable_detail_section.dart';

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
    final hasPoint = point != null;

    return ExpandableDetailSection(
      title: 'Lokasi Kejadian',
      icon: Icons.location_on_rounded,
      accentColor: AppColors.teal,
      subtitle: _text(alamat, fallback: 'Alamat belum tersedia.'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMap(point),
          if (hasPoint) ...[
            const SizedBox(height: 12),
            _buildCoordinates(),
            const SizedBox(height: 13),
            _buildGoogleMapsButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildMap(LatLng? point) {
    if (point == null) {
      return Container(
        height: 120,
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
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 180,
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

  Widget _buildCoordinates() {
    return Row(
      children: [
        const Icon(
          Icons.my_location_rounded,
          size: 14,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            '${ComplaintHelpers.formatCoordinate(latitude)}, '
            '${ComplaintHelpers.formatCoordinate(longitude)}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleMapsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 43,
      child: FilledButton.icon(
        onPressed: () => _openGoogleMaps(context),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.directions_rounded, size: 18),
        label: const Text(
          'Lihat Petunjuk Lokasi',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
