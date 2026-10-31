import 'package:elingk/app/routes/app_routes.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/controllers/news_controller.dart';
import 'package:elingk/modules/masyarakat/widgets/news/news_article_card.dart';
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

  @override
  void initState() {
    super.initState();

    controller = Get.find<NewsController>();
    scrollController = ScrollController()..addListener(_onScroll);

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

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();

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
          _buildSearch(),
          _buildFilter(),
          Expanded(
            child: Obx(() {
              final articles = controller.articles;

              if (controller.isLoading.value && articles.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.blue),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  articles.isEmpty) {
                return _buildError();
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
                  itemCount:
                      articles.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index >= articles.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.blue,
                          ),
                        ),
                      );
                    }

                    final article = articles[index];

                    return NewsArticleCard(
                      article: article,
                      horizontal: true,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.newsDetail,
                          arguments: article.id,
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // =======================================================
  // SEARCH
  // =======================================================

  Widget _buildSearch() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: TextField(
        onChanged: controller.search,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Cari berita atau pengumuman...',
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.blue),
          suffixIcon: Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    onPressed: controller.clearSearch,
                    icon: const Icon(Icons.close_rounded),
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.blue, width: 1),
          ),
        ),
      ),
    );
  }

  // =======================================================
  // FILTER
  // =======================================================

  Widget _buildFilter() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Obx(() {
        final selected = controller.selectedJenis.value;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip('Semua', 'semua', selected),
              const SizedBox(width: 8),
              _filterChip('Berita', 'berita', selected),
              const SizedBox(width: 8),
              _filterChip('Pengumuman', 'pengumuman', selected),
            ],
          ),
        );
      }),
    );
  }

  Widget _filterChip(String label, String value, String selected) {
    final isSelected = selected == value;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.changeJenis(value),
      showCheckmark: false,
      backgroundColor: const Color(0xFFF5F7FA),
      selectedColor: AppColors.blue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              Icons.wifi_off_rounded,
              color: AppColors.textSecondary,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
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

  // =======================================================
  // EMPTY
  // =======================================================

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
