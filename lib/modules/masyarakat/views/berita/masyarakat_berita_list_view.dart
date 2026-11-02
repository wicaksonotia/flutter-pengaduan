import 'package:elingk/app/routes/app_routes.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/controllers/news_controller.dart';
import 'package:elingk/modules/masyarakat/widgets/news/news_article_card.dart';
import 'package:elingk/modules/shared/widgets/berita/news_search.dart';
import 'package:elingk/modules/shared/widgets/berita/news_category_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsListView extends StatefulWidget {
  const NewsListView({super.key});

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  late final NewsController controller;
  late final ScrollController scrollController;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    controller = Get.find<NewsController>();

    scrollController = ScrollController()..addListener(_onScroll);

    searchController = TextEditingController();

    if (controller.articles.isEmpty) {
      controller.fetchArticles();
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final position = scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 250) {
      controller.loadMore();
    }
  }

  void _clearSearch() {
    controller.clearSearch();
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();

    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
        ),
        title: const Text(
          'Berita & Pengumuman',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          NewsSearch(
            controller: searchController,
            onChanged: controller.search,
            onClear: _clearSearch,
          ),

          const SizedBox(height: 8),

          Obx(
            () => NewsCategoryFilter(
              selectedJenis: controller.selectedJenis.value,
              onChanged: controller.changeJenis,
            ),
          ),

          Expanded(child: _buildArticleList()),
        ],
      ),
    );
  }

  Widget _buildArticleList() {
    return Obx(() {
      final articles = controller.articles.toList();
      final isLoading = controller.isLoading.value;
      final isLoadingMore = controller.isLoadingMore.value;
      final errorMessage = controller.errorMessage.value;

      if (isLoading && articles.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.blue),
        );
      }

      if (errorMessage.isNotEmpty && articles.isEmpty) {
        return _buildError(errorMessage);
      }

      if (articles.isEmpty) {
        return _buildEmpty();
      }

      return RefreshIndicator(
        color: AppColors.blue,
        onRefresh: controller.refreshArticles,
        child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: articles.length + (isLoadingMore ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            if (index >= articles.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.blue),
                ),
              );
            }

            final article = articles[index];

            return NewsArticleCard(
              article: article,
              horizontal: true,
              onTap: () {
                Get.toNamed(AppRoutes.newsDetail, arguments: article.id);
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: AppColors.textSecondary,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: controller.fetchArticles,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.article_outlined, size: 54, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Belum ada berita atau pengumuman',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Informasi terbaru dari instansi akan ditampilkan di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
