import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'complaint_form_styles.dart';

class ComplaintLocationCard extends StatelessWidget {
  const ComplaintLocationCard({
    super.key,
    required this.mapController,
    required this.selectedLocation,
    required this.locationSelected,
    required this.gettingLocation,
    required this.resolvingAddress,
    required this.submitting,
    required this.addressController,
    required this.onGetCurrentLocation,
    required this.onMapTap,
  });

  final MapController mapController;
  final LatLng selectedLocation;
  final bool locationSelected;
  final bool gettingLocation;
  final bool resolvingAddress;
  final bool submitting;
  final TextEditingController addressController;
  final VoidCallback onGetCurrentLocation;
  final ValueChanged<LatLng> onMapTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ComplaintFormStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.blueLight.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.navy,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Titik lokasi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Ketuk peta untuk menentukan lokasi.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Gunakan lokasi saat ini',
                  onPressed: gettingLocation || submitting
                      ? null
                      : onGetCurrentLocation,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.blueLight.withValues(
                      alpha: 0.35,
                    ),
                    foregroundColor: AppColors.blue,
                  ),
                  icon: gettingLocation
                      ? const SizedBox(
                          width: 19,
                          height: 19,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.blue,
                          ),
                        )
                      : const Icon(Icons.my_location_rounded),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
            child: SizedBox(
              height: 220,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: selectedLocation,
                      initialZoom: 14,
                      onTap: (_, point) {
                        if (!submitting) onMapTap(point);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.elingk.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: selectedLocation,
                            width: 44,
                            height: 50,
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.mapMarker,
                              size: 42,
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
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 15,
                            color: AppColors.blue,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Ketuk peta untuk memilih',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pin_drop_outlined,
                      color: AppColors.blue,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    const Expanded(
                      child: Text(
                        'Alamat kejadian',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (resolvingAddress) ...[
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Text(
                        'Mencari alamat...',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  minLines: 2,
                  maxLines: 4,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: ComplaintFormStyles.inputDecoration(
                    hint: 'Alamat otomatis muncul setelah memilih lokasi',
                    alignTop: true,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: locationSelected
                        ? AppColors.success.withValues(alpha: 0.09)
                        : AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        locationSelected
                            ? Icons.check_circle_outline_rounded
                            : Icons.info_outline_rounded,
                        size: 17,
                        color: locationSelected
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          locationSelected
                              ? 'Koordinat lokasi sudah dipilih.'
                              : 'Pilih lokasi melalui GPS atau ketuk peta.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: locationSelected
                                ? AppColors.success
                                : AppColors.textBody,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Koordinat: '
                  '${selectedLocation.latitude.toStringAsFixed(6)}, '
                  '${selectedLocation.longitude.toStringAsFixed(6)}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
