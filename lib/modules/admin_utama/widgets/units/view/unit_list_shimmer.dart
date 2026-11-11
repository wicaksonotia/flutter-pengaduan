import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sigapkawan/app/theme/app_colors.dart';

class UnitListShimmer extends StatelessWidget {
  const UnitListShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCard(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Shimmer.fromColors(
      baseColor: AppColors.border.withValues(alpha: 0.65),
      highlightColor: AppColors.surface,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _bone(width: 48, height: 48, radius: 14),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bone(width: 170, height: 14),
                      const SizedBox(height: 9),
                      _bone(width: 85, height: 10),
                    ],
                  ),
                ),
                _bone(width: 55, height: 24, radius: 20),
              ],
            ),
            const SizedBox(height: 18),
            _bone(width: double.infinity, height: 1),
            const SizedBox(height: 16),
            _buildInfoBone(),
            const SizedBox(height: 12),
            _buildInfoBone(),
            const SizedBox(height: 12),
            _buildInfoBone(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBone() {
    return Row(
      children: [
        _bone(width: 18, height: 18, radius: 5),
        const SizedBox(width: 10),
        _bone(width: 65, height: 10),
        const SizedBox(width: 14),
        Expanded(child: _bone(width: double.infinity, height: 11)),
      ],
    );
  }

  Widget _bone({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
