import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/theme/app_colors.dart';

import 'package:elingk/modules/admin_utama/bindings/admin_utama_berita_binding.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_utama_berita_controller.dart';
import 'package:elingk/modules/shared/widgets/berita/admin_berita_header.dart';

import 'package:elingk/modules/shared/widgets/berita/news_article_form_dialog.dart';
import 'package:elingk/modules/shared/widgets/berita/news_category_filter.dart';
import 'package:elingk/modules/shared/widgets/berita/news_delete_dialog.dart';
import 'package:elingk/modules/shared/widgets/berita/news_management_list.dart';
import 'package:elingk/modules/shared/widgets/berita/news_search.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUtamaBeritaView extends StatefulWidget {
  const AdminUtamaBeritaView({super.key});

  @override
  State<AdminUtamaBeritaView> createState() => _AdminUtamaBeritaViewState();
}

class _AdminUtamaBeritaViewState extends State<AdminUtamaBeritaView> {
  late final AdminUtamaBeritaController controller;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<AdminUtamaBeritaController>()) {
      AdminUtamaBeritaBinding().dependencies();
    }

    controller = Get.find<AdminUtamaBeritaController>();
  }

  // ============================================================
  // CREATE
  // ============================================================

  Future<void> _createArticle() async {
    final data = await Get.dialog<Map<String, dynamic>>(
      const NewsArticleFormDialog(),
      barrierDismissible: false,
    );

    if (data == null) return;

    await controller.createArticle(data: data);
  }

  // ============================================================
  // EDIT
  // ============================================================

  Future<void> _editArticle(BeritaPengumumanModel article) async {
    final data = await Get.dialog<Map<String, dynamic>>(
      NewsArticleFormDialog(article: article),
      barrierDismissible: false,
    );

    if (data == null) return;

    await controller.updateArticle(id: article.id, data: data);
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> _deleteArticle(BeritaPengumumanModel article) async {
    final confirmed = await showNewsDeleteDialog(title: article.judul);

    if (!confirmed) return;

    await controller.deleteArticle(article.id);
  }

  // ============================================================
  // BUILD
  // ============================================================

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
          // ====================================================
          // HEADER / FILTER INSTANSI
          // ====================================================

          AdminBeritaHeader(controller: controller),

          // ====================================================
          // SEARCH
          // ====================================================
          NewsSearch(
            controller: controller.searchController,
            onSubmitted: controller.search,
            onClear: controller.clearSearch,
          ),

          // ====================================================
          // FILTER KATEGORI
          // ====================================================
          Obx(
            () => NewsCategoryFilter(
              selectedJenis: controller.selectedJenis.value,
              onChanged: controller.changeJenis,
            ),
          ),

          const SizedBox(height: 8),

          // ====================================================
          // ARTICLE LIST
          // ====================================================
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
                emptyMessage: 'Belum ada berita atau pengumuman yang tersedia.',

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

      // ========================================================
      // ADD BUTTON
      // ========================================================
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
