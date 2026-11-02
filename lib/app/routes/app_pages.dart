import 'package:elingk/modules/admin_unit/bindings/admin_unit_berita_binding.dart';
import 'package:elingk/modules/admin_unit/bindings/admin_unit_binding.dart';
import 'package:elingk/modules/admin_unit/views/berita/admin_unit_berita_view.dart';
import 'package:elingk/modules/admin_utama/bindings/admin_utama_berita_binding.dart';
import 'package:elingk/modules/admin_utama/views/berita/admin_utama_berita_view.dart';
import 'package:get/get.dart';

// Routes
import 'app_routes.dart';

// Masyarakat
import 'package:elingk/modules/masyarakat/bindings/home_binding.dart';
import 'package:elingk/modules/masyarakat/bindings/news_binding.dart';
import 'package:elingk/modules/masyarakat/bindings/news_detail_binding.dart';

import 'package:elingk/modules/masyarakat/views/home/home_view.dart';
import 'package:elingk/modules/masyarakat/views/berita/masyarakat_berita_list_view.dart';
import 'package:elingk/modules/masyarakat/views/berita/masyarakat_berita_detail_view.dart';

// Admin
import 'package:elingk/modules/admin_utama/views/dashboard/admin_utama_dashboard_view.dart';
import 'package:elingk/modules/admin_unit/views/dashboard/admin_unit_dashboard_view.dart';
import 'package:elingk/modules/field_officer/views/dashboard/field_officer_dashboard_view.dart';

class AppPages {
  static final pages = [
    // ==========================================
    // MASYARAKAT
    // ==========================================

    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.news,
      page: () => const NewsListView(),
      binding: NewsBinding(),
    ),

    GetPage(
      name: AppRoutes.newsDetail,
      page: () {
        final articleId = Get.arguments as int;

        return NewsDetailView(articleId: articleId);
      },
      binding: NewsDetailBinding(),
    ),

    // ==========================================
    // ADMIN UTAMA
    // ==========================================
    GetPage(
      name: AppRoutes.adminUtama,
      page: () => const AdminUtamaDashboardView(),
    ),

    GetPage(
      name: AppRoutes.adminUtamaBerita,
      page: () => const AdminUtamaBeritaView(),
      binding: AdminUtamaBeritaBinding(),
    ),

    // ==========================================
    // ADMIN UNIT
    // ==========================================
    GetPage(
      name: AppRoutes.adminUnit,
      page: () => const AdminUnitDashboardView(),
      binding: AdminUnitBinding(),
    ),

    GetPage(
      name: AppRoutes.adminUnitBerita,
      page: () => const AdminUnitBeritaView(),
      binding: AdminUnitBeritaBinding(),
    ),

    // ==========================================
    // FIELD OFFICER
    // ==========================================
    GetPage(
      name: AppRoutes.fieldOfficer,
      page: () => const FieldOfficerDashboardView(),
    ),
  ];
}
