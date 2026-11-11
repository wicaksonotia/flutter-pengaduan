import 'package:sigapkawan/app/data/models/berita_pengumuman_model.dart';
import 'package:sigapkawan/modules/shared/widgets/berita/news_article_card.dart';
import 'package:flutter/material.dart';

class NewsArticleList extends StatelessWidget {
  final List<BeritaPengumumanModel> articles;
  final bool showActions;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final ValueChanged<BeritaPengumumanModel>? onTap;
  final ValueChanged<BeritaPengumumanModel>? onEdit;
  final ValueChanged<BeritaPengumumanModel>? onDelete;

  const NewsArticleList({
    super.key,
    required this.articles,
    this.showActions = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: articles.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= articles.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final article = articles[index];

        return NewsArticleCard(
          article: article,
          showActions: showActions,
          onTap: onTap == null ? null : () => onTap!(article),
          onEdit: onEdit == null ? null : () => onEdit!(article),
          onDelete: onDelete == null ? null : () => onDelete!(article),
        );
      },
    );
  }
}
