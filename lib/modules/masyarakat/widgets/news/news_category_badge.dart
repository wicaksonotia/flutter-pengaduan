import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NewsCategoryBadge extends StatelessWidget {
  const NewsCategoryBadge({
    super.key,
    required this.jenis,
    this.compact = false,
  });

  final String jenis;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isPengumuman = jenis.toLowerCase() == 'pengumuman';

    final label = isPengumuman ? 'Pengumuman' : 'Berita';
    final color = isPengumuman ? AppColors.warning : AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 11,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: compact ? 10 : 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
