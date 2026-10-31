import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/utils/news_helper.dart';
import 'package:flutter/material.dart';

class NewsImage extends StatelessWidget {
  const NewsImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    this.placeholderIcon = Icons.newspaper_rounded,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final url = NewsHelper.resolveImageUrl(imageUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => _placeholder(),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;

            return _placeholder(
              child: const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _placeholder({Widget? child}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.background,
      alignment: Alignment.center,
      child:
          child ??
          Icon(placeholderIcon, size: 30, color: AppColors.textSecondary),
    );
  }
}
