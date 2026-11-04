import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardStatsShimmer extends StatelessWidget {
  const DashboardStatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total pengaduan
            Row(
              children: [
                _box(width: 42, height: 42, radius: 13),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 105, height: 10),
                      const SizedBox(height: 6),
                      _box(width: 55, height: 24),
                      const SizedBox(height: 4),
                      _box(width: 130, height: 9),
                    ],
                  ),
                ),
                _box(width: 70, height: 25, radius: 20),
              ],
            ),

            const SizedBox(height: 18),

            // Judul grafik
            _box(width: 135, height: 12),
            const SizedBox(height: 10),

            // Grafik distribusi
            _box(width: double.infinity, height: 11, radius: 20),

            const SizedBox(height: 16),

            // Dua legenda status
            Row(
              children: [
                Expanded(child: _legendItem()),
                const SizedBox(width: 12),
                Expanded(child: _legendItem()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem() {
    return Row(
      children: [
        _box(width: 9, height: 9, radius: 3),
        const SizedBox(width: 7),
        Expanded(child: _box(width: 65, height: 10)),
        const SizedBox(width: 4),
        _box(width: 20, height: 12),
      ],
    );
  }

  Widget _box({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
