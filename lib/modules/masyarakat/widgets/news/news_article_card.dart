import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/utils/news_helper.dart';
import 'package:elingk/modules/masyarakat/widgets/news/news_category_badge.dart';
import 'package:elingk/modules/masyarakat/widgets/news/news_image.dart';
import 'package:flutter/material.dart';

class NewsArticleCard extends StatelessWidget {
  const NewsArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.horizontal = false,
  });

  final BeritaPengumumanModel article;
  final VoidCallback onTap;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return _buildHorizontalCard();
    }

    return _buildVerticalCard();
  }

  Widget _buildVerticalCard() {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsImage(
              imageUrl: article.gambarUrl,
              width: double.infinity,
              height: 175,
              borderRadius: 16,
            ),
            Padding(padding: const EdgeInsets.all(14), child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCard() {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewsImage(
                imageUrl: article.gambarUrl,
                width: 108,
                height: 100,
                borderRadius: 10,
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NewsCategoryBadge(jenis: article.jenis, compact: true),
        const SizedBox(height: 9),
        Text(
          article.judul,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
        if (article.ringkasan != null && article.ringkasan!.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            article.ringkasan!,
            maxLines: horizontal ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
        const SizedBox(height: 9),
        Text(
          NewsHelper.formatDate(article.publishedAt ?? article.createdAt),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}
