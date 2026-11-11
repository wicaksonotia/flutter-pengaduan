import 'package:sigapkawan/app/data/models/berita_pengumuman_model.dart';
import 'package:sigapkawan/app/theme/app_colors.dart';
import 'package:sigapkawan/modules/admin_unit/bindings/admin_unit_berita_binding.dart';
import 'package:sigapkawan/modules/admin_unit/controllers/admin_unit_berita_controller.dart';
import 'package:sigapkawan/modules/shared/widgets/berita/news_article_form_dialog.dart';
import 'package:sigapkawan/modules/shared/widgets/berita/news_category_filter.dart';
import 'package:sigapkawan/modules/shared/widgets/berita/news_delete_dialog.dart';
import 'package:sigapkawan/modules/shared/widgets/berita/news_management_list.dart';
import 'package:sigapkawan/modules/shared/widgets/berita/news_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUnitBeritaView extends StatefulWidget {
  const AdminUnitBeritaView({super.key});

  @override
  State<AdminUnitBeritaView> createState() => _AdminUnitBeritaViewState();
}

class _AdminUnitBeritaViewState extends State<AdminUnitBeritaView> {
  late final AdminUnitBeritaController controller;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<AdminUnitBeritaController>()) {
      AdminUnitBeritaBinding().dependencies();
    }

    controller = Get.find<AdminUnitBeritaController>();
  }

  Future<void> _createArticle() async {
    final data = await Get.dialog<Map<String, dynamic>>(
      const NewsArticleFormDialog(),
      barrierDismissible: false,
    );

    if (data == null) return;

    await controller.createArticle(data: data);
  }

  Future<void> _editArticle(BeritaPengumumanModel article) async {
    final data = await Get.dialog<Map<String, dynamic>>(
      NewsArticleFormDialog(article: article),
      barrierDismissible: false,
    );

    if (data == null) return;

    await controller.updateArticle(id: article.id, data: data);
  }

  Future<void> _deleteArticle(BeritaPengumumanModel article) async {
    final confirmed = await showNewsDeleteDialog(title: article.judul);

    if (!confirmed) return;

    await controller.deleteArticle(article.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Berita & Pengumuman',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          NewsSearch(
            controller: controller.searchController,
            onSubmitted: controller.search,
            onClear: controller.clearSearch,
          ),

          Obx(
            () => NewsCategoryFilter(
              selectedJenis: controller.selectedJenis.value,
              onChanged: controller.changeJenis,
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: Obx(
              () => NewsManagementList(
                articles: controller.articles.toList(),
                isLoading: controller.isLoading.value,
                isLoadingMore: controller.isLoadingMore.value,
                hasError: controller.errorMessage.value.isNotEmpty,
                errorMessage: controller.errorMessage.value,
                hasNextPage: controller.hasNextPage,
                emptyTitle: 'Belum ada berita',
                emptyMessage: 'Silakan tambahkan berita atau pengumuman untuk instansi ini.',
                onRefresh: controller.refreshArticles,
                onRetry: controller.refreshArticles,
                onLoadMore: controller.loadMore,
                showActions: true,
                onEdit: _editArticle,
                onDelete: _deleteArticle,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createArticle,
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Berita',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
