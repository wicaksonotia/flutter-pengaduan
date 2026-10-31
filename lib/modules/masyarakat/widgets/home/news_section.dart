import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/routes/app_routes.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/controllers/news_controller.dart';
import 'package:elingk/modules/masyarakat/utils/news_helper.dart';
import 'package:elingk/modules/masyarakat/widgets/news/news_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'section_header.dart';

class NewsSection extends GetView<NewsController> {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final articles = controller.articles;

      final pengumuman = articles.where((item) => item.isPengumuman).toList();
      final berita = articles.where((item) => item.isBerita).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Berita & Pengumuman',
            actionLabel: 'Lihat semua',
            onAction: () {
              Get.toNamed(AppRoutes.news);
            },
          ),
          const SizedBox(height: 12),

          if (controller.isLoading.value && articles.isEmpty)
            const _NewsLoading()
          else if (controller.errorMessage.value.isNotEmpty && articles.isEmpty)
            _NewsError(
              message: controller.errorMessage.value,
              onRetry: controller.fetchArticles,
            )
          else ...[
            if (pengumuman.isNotEmpty) ...[
              _AnnouncementCard(
                article: pengumuman.first,
                onTap: () => _openDetail(pengumuman.first),
              ),
              const SizedBox(height: 18),
            ],

            const Text(
              'Berita Terbaru',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),

            if (berita.isEmpty)
              const _EmptyNews(message: 'Belum ada berita terbaru.')
            else
              SizedBox(
                height: 205,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: berita.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final article = berita[index];

                    return _NewsCard(
                      article: article,
                      onTap: () => _openDetail(article),
                    );
                  },
                ),
              ),
          ],
        ],
      );
    });
  }

  void _openDetail(BeritaPengumumanModel article) {
    Get.toNamed(AppRoutes.newsDetail, arguments: article.id);
  }
}

// =======================================================
// ANNOUNCEMENT CARD
// =======================================================

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.article, required this.onTap});

  final BeritaPengumumanModel article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF7E8),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF7E4B9)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9BD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.campaign_rounded,
                  color: Color(0xFFB97812),
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PENGUMUMAN PENTING',
                      style: TextStyle(
                        color: Color(0xFFB97812),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      article.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if ((article.ringkasan ?? '').isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        article.ringkasan!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          size: 14,
                          color: Color(0xFFB97812),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            article.instansi?.nama ??
                                'Informasi resmi instansi',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF8B6B3E),
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Text(
                          NewsHelper.formatDate(article.publishedAt),
                          style: const TextStyle(
                            color: Color(0xFF8B6B3E),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFB97812),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// NEWS CARD
// =======================================================

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.article, required this.onTap});

  final BeritaPengumumanModel article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEBEFF5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewsImage(
                  imageUrl: article.gambarUrl,
                  width: double.infinity,
                  height: 85,
                  borderRadius: 12,
                  placeholderIcon: Icons.article_outlined,
                ),
                const SizedBox(height: 10),
                Text(
                  article.instansi?.nama.toUpperCase() ?? 'INFORMASI INSTANSI',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  article.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Text(
                  NewsHelper.formatDate(article.publishedAt),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================================
// LOADING, ERROR, EMPTY
// =======================================================

class _NewsLoading extends StatelessWidget {
  const _NewsLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 150,
      child: Center(child: CircularProgressIndicator(color: AppColors.blue)),
    );
  }
}

class _NewsError extends StatelessWidget {
  const _NewsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 28),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }
}

class _EmptyNews extends StatelessWidget {
  const _EmptyNews({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    );
  }
}
