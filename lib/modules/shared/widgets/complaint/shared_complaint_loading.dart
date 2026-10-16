import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SharedComplaintLoading extends StatefulWidget {
  const SharedComplaintLoading({
    super.key,
    this.itemCount = 4,
    this.showSummary = true,
  });

  final int itemCount;
  final bool showSummary;

  @override
  State<SharedComplaintLoading> createState() => _SharedComplaintLoadingState();
}

class _SharedComplaintLoadingState extends State<SharedComplaintLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox({
    required double height,
    double? width,
    double radius = 8,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value * 2 - 1;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(progress - 1, 0),
              end: Alignment(progress + 1, 0),
              colors: [AppColors.border, AppColors.surface, AppColors.border],
              stops: const [0.1, 0.5, 0.9],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _buildSummarySkeleton() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(height: 12, width: 110),
                const SizedBox(height: 10),
                _shimmerBox(height: 17, width: 175),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _shimmerBox(height: 36, width: 48, radius: 10),
        ],
      ),
    );
  }

  Widget _buildComplaintSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _shimmerBox(height: 13, width: 145)),
              const SizedBox(width: 12),
              _shimmerBox(height: 25, width: 82, radius: 20),
            ],
          ),
          const SizedBox(height: 18),
          _shimmerBox(height: 17, width: 220),
          const SizedBox(height: 10),
          _shimmerBox(height: 12),
          const SizedBox(height: 7),
          _shimmerBox(height: 12, width: 190),
          const SizedBox(height: 16),
          Row(
            children: [
              _shimmerBox(height: 12, width: 100),
              const Spacer(),
              _shimmerBox(height: 12, width: 85),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showSummary) ...[
            _buildSummarySkeleton(),
            const SizedBox(height: 20),
            _shimmerBox(height: 18, width: 150),
            const SizedBox(height: 12),
            _shimmerBox(height: 48),
            const SizedBox(height: 20),
            _shimmerBox(height: 20, width: 160),
            const SizedBox(height: 12),
          ],
          ...List.generate(widget.itemCount, (_) => _buildComplaintSkeleton()),
        ],
      ),
    );
  }
}
