import 'package:flutter/material.dart';
import 'package:sapahub/app/theme/app_colors.dart';

class UnitStatusBadge extends StatelessWidget {
  const UnitStatusBadge({super.key, required this.aktif});

  final bool aktif;

  @override
  Widget build(BuildContext context) {
    final color = aktif ? AppColors.blue : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            aktif ? 'Aktif' : 'Nonaktif',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
