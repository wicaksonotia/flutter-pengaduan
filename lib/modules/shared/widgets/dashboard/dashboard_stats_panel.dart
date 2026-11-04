import 'dart:math' as math;

import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/widgets/dashboard/dashboard_stats_shimmer.dart';
import 'package:flutter/material.dart';

class DashboardStatItem {
  final String title;
  final int value;
  final Color color;

  const DashboardStatItem({
    required this.title,
    required this.value,
    required this.color,
  });
}

class DashboardStatsPanel extends StatelessWidget {
  final int total;
  final List<DashboardStatItem> items;

  final String totalTitle;
  final String totalSubtitle;
  final String chartTitle;

  final bool isLoading;
  final String errorMessage;
  final VoidCallback? onRetry;

  const DashboardStatsPanel({
    super.key,
    required this.total,
    required this.items,
    this.totalTitle = 'Total Pengaduan',
    this.totalSubtitle = 'Seluruh laporan masuk',
    this.chartTitle = 'Distribusi Pengaduan',
    this.isLoading = false,
    this.errorMessage = '',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && total == 0 && items.every((e) => e.value == 0)) {
      return const DashboardStatsShimmer();
    }

    if (errorMessage.isNotEmpty &&
        total == 0 &&
        items.every((e) => e.value == 0)) {
      return _StatsError(message: errorMessage, onRetry: onRetry);
    }

    final groupedTotal = items.fold<int>(
      0,
      (sum, item) => sum + math.max(0, item.value),
    );

    final other = math.max(0, total - groupedTotal);
    final chartTotal = math.max(total, groupedTotal);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.inbox_rounded,
                  color: AppColors.navy,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      totalTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 28,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      totalSubtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Ringkasan',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Ringkasan',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 22),

          // Grafik
          Text(
            chartTitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 13,
              child: Row(
                children: [
                  if (chartTotal == 0)
                    Expanded(child: Container(color: AppColors.border))
                  else ...[
                    ...items
                        .where((item) => item.value > 0)
                        .map(
                          (item) => Expanded(
                            flex: item.value,
                            child: Container(color: item.color),
                          ),
                        ),
                    if (other > 0)
                      Expanded(
                        flex: other,
                        child: Container(color: AppColors.textMuted),
                      ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Legenda
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 3.8,
            ),
            itemBuilder: (context, index) {
              return _StatusLegend(item: items[index]);
            },
          ),

          if (other > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Text(
                    'Status lainnya',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  '$other',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusLegend extends StatelessWidget {
  final DashboardStatItem item;

  const _StatusLegend({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${item.value}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _StatsError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _StatsError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 28,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
