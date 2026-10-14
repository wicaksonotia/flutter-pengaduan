import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/widgets/app_confirm_dialog.dart';
import 'package:elingk/app/widgets/app_empty_state.dart';
import 'package:elingk/app/widgets/app_header.dart';
import 'package:elingk/app/widgets/app_hero_card.dart';
import 'package:elingk/app/widgets/app_search_field.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_complaint_categories_controller.dart';
import 'package:elingk/modules/admin_utama/widgets/categories/category_card.dart';
import 'package:elingk/modules/admin_utama/widgets/categories/category_form_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminComplaintCategoriesView extends StatelessWidget {
  AdminComplaintCategoriesView({super.key});

  final AdminComplaintCategoriesController controller = Get.put(
    AdminComplaintCategoriesController(),
  );

  Future<void> _openForm(
    BuildContext context, {
    Map<String, dynamic>? category,
  }) async {
    await CategoryFormBottomSheet.show(context, category: category);
  }

  Future<void> _deleteCategory(
    BuildContext context,
    Map<String, dynamic> category,
  ) async {
    final id = int.tryParse(category['id']?.toString() ?? '');

    if (id == null) {
      Get.snackbar(
        'Gagal',
        'ID kategori tidak valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final nama = (category['nama'] ?? 'Kategori ini').toString();

    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Hapus Kategori?',
      message:
          'Kategori "$nama" akan dihapus. Kategori yang sudah '
          'digunakan oleh pengaduan tidak dapat dihapus.',
      confirmText: 'Ya, Hapus',
      isDestructive: true,
      icon: Icons.delete_outline_rounded,
    );

    if (confirmed != true) return;

    await controller.deleteCategory(id);
  }

  Future<void> _refresh() async {
    await Future.wait([controller.fetchCategories(), controller.fetchUnits()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSoft,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Kategori Pengaduan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final filtered = controller.filteredCategories;
          final isSearching = controller.searchQuery.value.trim().isNotEmpty;

          return RefreshIndicator(
            onRefresh: _refresh,
            color: AppColors.blue,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
              children: [
                const AppHeroCard(
                  title: 'Kategori Pengaduan',
                  description:
                      'Kelola kategori dan tentukan unit tujuan '
                      'untuk setiap kategori.',
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 22),

                AppSearchField(
                  hintText: 'Cari nama, deskripsi, atau unit...',
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                ),
                const SizedBox(height: 22),

                AppHeader(
                  title: 'Daftar Kategori',
                  subtitle:
                      '${controller.categories.length} kategori ditemukan',
                  badgeText:
                      '${controller.categories.where((item) {
                        return item['aktif'] == true || item['aktif'] == 1;
                      }).length} aktif',
                ),
                const SizedBox(height: 14),

                if (controller.isLoading.value && controller.categories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (filtered.isEmpty)
                  AppEmptyState(
                    title: isSearching
                        ? 'Kategori tidak ditemukan'
                        : 'Belum ada kategori',
                    description: isSearching
                        ? 'Coba kata kunci pencarian yang berbeda.'
                        : 'Tambahkan kategori agar pengaduan dapat '
                              'dikelompokkan berdasarkan unit tujuan.',
                    icon: isSearching
                        ? Icons.search_off_rounded
                        : Icons.category_outlined,
                    showButton: !isSearching,
                    buttonText: 'Tambah Kategori',
                    onButtonPressed: () => _openForm(context),
                  )
                else
                  ...filtered.map(
                    (category) => Padding(
                      key: ValueKey(category['id']),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CategoryCard(
                        category: category,
                        onEdit: () => _openForm(context, category: category),
                        onDelete: () => _deleteCategory(context, category),
                        onToggleActive: () =>
                            _toggleCategoryActive(context, category),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.textOnPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Kategori',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _toggleCategoryActive(
    BuildContext context,
    Map<String, dynamic> category,
  ) async {
    final nama = (category['nama'] ?? 'Kategori ini').toString();
    final rawActive = category['aktif'];
    final active =
        rawActive == true ||
        rawActive == 1 ||
        rawActive?.toString().toLowerCase() == 'true' ||
        rawActive?.toString() == '1';

    final confirmed = await AppConfirmDialog.show(
      context,
      title: active ? 'Nonaktifkan Kategori?' : 'Aktifkan Kategori?',
      message: active
          ? 'Kategori "$nama" akan dinonaktifkan.'
          : 'Kategori "$nama" akan diaktifkan kembali.',
      confirmText: active ? 'Ya, Nonaktifkan' : 'Ya, Aktifkan',
      isDestructive: active,
      icon: active ? Icons.toggle_off_outlined : Icons.toggle_on_outlined,
    );

    if (confirmed != true) return;

    await controller.toggleCategoryActive(category);
  }
}
