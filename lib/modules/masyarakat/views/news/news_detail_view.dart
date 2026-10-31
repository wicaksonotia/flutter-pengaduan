import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/controllers/news_detail_controller.dart';
import 'package:elingk/modules/masyarakat/utils/news_helper.dart';
import 'package:elingk/modules/masyarakat/widgets/news/news_category_badge.dart';
import 'package:elingk/modules/masyarakat/widgets/news/news_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsDetailView extends StatefulWidget {
  const NewsDetailView({super.key, required this.articleId});

  final int articleId;

  @override
  State<NewsDetailView> createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<NewsDetailView> {
  late final NewsDetailController controller;
  late final String controllerTag;

  @override
  void initState() {
    super.initState();

    // Setiap halaman detail memiliki controller sendiri.
    controllerTag = 'news-detail-${identityHashCode(this)}';

    controller = Get.find<NewsDetailController>();

    controller.fetchDetail(widget.articleId);
  }

  @override
  void dispose() {
    Get.delete<NewsDetailController>(tag: controllerTag, force: true);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
        ),
        title: const Text(
          'Detail Informasi',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Obx(() {
        final article = controller.selectedArticle.value;

        if (controller.isDetailLoading.value && article == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.blue),
          );
        }

        if (article == null) {
          return _buildError();
        }

        // Pastikan artikel sesuai dengan ID yang diminta.
        if (article.id != widget.articleId) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.blue),
          );
        }

        return _buildContent(article);
      }),
    );
  }

  // =======================================================
  // ARTICLE CONTENT
  // =======================================================

  Widget _buildContent(BeritaPengumumanModel article) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ARTICLE IMAGE
          NewsImage(
            imageUrl: article.gambarUrl,
            width: double.infinity,
            height: 230,
            borderRadius: 20,
            placeholderIcon: Icons.article_outlined,
          ),

          const SizedBox(height: 20),

          // CATEGORY
          NewsCategoryBadge(jenis: article.jenis),

          const SizedBox(height: 13),

          // TITLE
          Text(
            article.judul,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 14),

          // INSTITUTION
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.account_balance_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  article.instansi?.nama ?? 'Instansi',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // PUBLISHED DATE
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 7),
              Text(
                NewsHelper.formatDate(article.publishedAt, fullMonth: true),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Color(0xFFEBEFF5), height: 1),
          ),

          // SUMMARY
          if ((article.ringkasan ?? '').isNotEmpty) ...[
            Text(
              article.ringkasan!,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ARTICLE BODY
          SelectableText(
            article.konten ?? '',
            style: const TextStyle(
              color: Color(0xFF465366),
              fontSize: 14,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  // =======================================================
  // ERROR
  // =======================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.article_outlined,
              color: AppColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'Informasi tidak ditemukan.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () {
                controller.refreshDetail(widget.articleId);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
