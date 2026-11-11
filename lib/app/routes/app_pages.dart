import 'package:sigapkawan/modules/admin_unit/bindings/admin_unit_berita_binding.dart';
import 'package:sigapkawan/modules/admin_unit/bindings/admin_unit_binding.dart';
import 'package:sigapkawan/modules/admin_unit/bindings/admin_unit_complaints_binding.dart';
import 'package:sigapkawan/modules/admin_unit/views/berita/admin_unit_berita_view.dart';
import 'package:sigapkawan/modules/admin_unit/views/complaints/admin_unit_complaints_view.dart';
import 'package:sigapkawan/modules/admin_utama/bindings/admin_utama_berita_binding.dart';
import 'package:sigapkawan/modules/admin_utama/bindings/admin_utama_binding.dart';
import 'package:sigapkawan/modules/admin_utama/bindings/admin_utama_complaints_binding.dart';
import 'package:sigapkawan/modules/admin_utama/bindings/admin_utama_unit_binding.dart';
import 'package:sigapkawan/modules/admin_utama/views/berita/admin_utama_berita_view.dart';
import 'package:sigapkawan/modules/admin_utama/views/complaints/admin_complaints_view.dart';
import 'package:sigapkawan/modules/admin_utama/views/units/admin_utama_units_view.dart';
import 'package:sigapkawan/modules/field_officer/bindings/field_officer_binding.dart';
import 'package:sigapkawan/modules/field_officer/bindings/field_officer_complaints_binding.dart';
import 'package:sigapkawan/modules/field_officer/views/complaints/field_officer_complaints_view.dart';
import 'package:sigapkawan/modules/shared/bindings/shared_profile_binding.dart';
import 'package:sigapkawan/modules/shared/views/shared_profile_view.dart';
import 'package:get/get.dart';

// Routes
import 'app_routes.dart';

// Masyarakat
import 'package:sigapkawan/modules/masyarakat/bindings/home_binding.dart';
import 'package:sigapkawan/modules/masyarakat/bindings/news_binding.dart';
import 'package:sigapkawan/modules/masyarakat/bindings/news_detail_binding.dart';

import 'package:sigapkawan/modules/masyarakat/views/home/home_view.dart';
import 'package:sigapkawan/modules/masyarakat/views/berita/masyarakat_berita_list_view.dart';
import 'package:sigapkawan/modules/masyarakat/views/berita/masyarakat_berita_detail_view.dart';

// Admin
import 'package:sigapkawan/modules/admin_utama/views/dashboard/admin_utama_dashboard_view.dart';
import 'package:sigapkawan/modules/admin_unit/views/dashboard/admin_unit_dashboard_view.dart';
import 'package:sigapkawan/modules/field_officer/views/dashboard/field_officer_dashboard_view.dart';

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
      binding: AdminUtamaBinding(),
    ),

    GetPage(
      name: AppRoutes.adminUtamaBerita,
      page: () => const AdminUtamaBeritaView(),
      binding: AdminUtamaBeritaBinding(),
    ),

    GetPage(
      name: AppRoutes.adminUtamaComplaints,
      page: () => const AdminComplaintsView(),
      binding: AdminUtamaComplaintsBinding(),
    ),

    GetPage(
      name: AppRoutes.adminUtamaProfile,
      page: () => const SharedProfileView(),
      binding: SharedProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.adminUtamaUnits,
      page: () => const AdminUtamaUnitsView(),
      binding: AdminUtamaUnitBinding(),
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

    GetPage(
      name: AppRoutes.adminUnitComplaints,
      page: () => const AdminUnitComplaintsView(),
      binding: AdminUnitComplaintsBinding(),
    ),

    GetPage(
      name: AppRoutes.adminUnitProfile,
      page: () => const SharedProfileView(),
      binding: SharedProfileBinding(),
    ),

    // ==========================================
    // FIELD OFFICER
    // ==========================================
    GetPage(
      name: AppRoutes.fieldOfficer,
      page: () => const FieldOfficerDashboardView(),
      binding: FieldOfficerBinding(),
    ),

    GetPage(
      name: AppRoutes.fieldOfficerComplaints,
      page: () => const FieldOfficerComplaintsView(),
      binding: FieldOfficerComplaintsBinding(),
    ),

    GetPage(
      name: AppRoutes.fieldOfficerProfile,
      page: () => const SharedProfileView(),
      binding: SharedProfileBinding(),
    ),
  ];
}
