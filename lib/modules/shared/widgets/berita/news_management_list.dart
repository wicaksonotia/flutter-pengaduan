import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/shared/widgets/berita/news_article_card.dart';
import 'package:elingk/modules/shared/widgets/berita/news_list_state.dart';
import 'package:flutter/material.dart';

class NewsManagementList extends StatelessWidget {
  final List<BeritaPengumumanModel> articles;

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String errorMessage;
  final bool hasNextPage;

  final String emptyTitle;
  final String emptyMessage;

  final Future<void> Function() onRefresh;
  final Future<void> Function()? onLoadMore;
  final VoidCallback? onRetry;

  final bool showActions;
  final ValueChanged<BeritaPengumumanModel>? onTap;
  final ValueChanged<BeritaPengumumanModel>? onEdit;
  final ValueChanged<BeritaPengumumanModel>? onDelete;

  const NewsManagementList({
    super.key,
    required this.articles,
    required this.onRefresh,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage = '',
    this.hasNextPage = false,
    this.emptyTitle = 'Belum ada informasi',
    this.emptyMessage = 'Berita atau pengumuman belum tersedia.',
    this.onLoadMore,
    this.onRetry,
    this.showActions = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.navy,
      onRefresh: onRefresh,
      child: CustomScrollView(
        // Wajib agar pull-to-refresh tetap aktif saat konten pendek/kosong.
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (isLoading && articles.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: NewsLoading(),
            )
          else if (hasError && articles.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: NewsError(
                message: errorMessage,
                onRetry: onRetry ?? onRefresh,
              ),
            )
          else if (articles.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: NewsEmpty(title: emptyTitle, message: emptyMessage),
            )
          else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final article = articles[index];

                  return NewsArticleCard(
                    article: article,
                    showActions: showActions,
                    onTap: onTap == null ? null : () => onTap!(article),
                    onEdit: onEdit == null ? null : () => onEdit!(article),
                    onDelete: onDelete == null
                        ? null
                        : () => onDelete!(article),
                  );
                }, childCount: articles.length),
              ),
            ),

            if (hasNextPage)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoadingMore || onLoadMore == null
                          ? null
                          : onLoadMore,
                      child: isLoadingMore
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Muat Berita Berikutnya'),
                    ),
                  ),
                ),
              )
            else
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ],
      ),
    );
  }
}
