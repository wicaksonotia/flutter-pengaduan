import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/bindings/admin_utama_binding.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_utama_controller.dart';
import 'package:elingk/modules/admin_utama/views/categories/admin_complaint_categories_view.dart';
import 'package:elingk/modules/admin_utama/views/complaints/admin_complaints_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUtamaDashboardView extends StatefulWidget {
  const AdminUtamaDashboardView({super.key});

  @override
  State<AdminUtamaDashboardView> createState() =>
      _AdminUtamaDashboardViewState();
}

class _AdminUtamaDashboardViewState extends State<AdminUtamaDashboardView> {
  late final AdminUtamaController controller;

  @override
  void initState() {
    super.initState();
    AdminUtamaBinding().dependencies();
    controller = Get.find<AdminUtamaController>();
  }

  void _showComingSoon(String title) {
    Get.snackbar(
      title,
      'Modul ini akan kita bangun pada tahap berikutnya.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(
          () => CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.primaryGradient,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 13),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'eLingk',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Panel Admin Utama',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Profil',
                          onPressed: () => _showComingSoon('Profil'),
                          icon: const Icon(
                            Icons.account_circle_outlined,
                            color: AppColors.navy,
                            size: 29,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.primaryGradient,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Pantau pengaduan masyarakat dan '
                            'koordinasikan tindak lanjut antarunit.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 27),
                    const Text(
                      'Ringkasan Pengaduan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      children: [
                        _StatCard(
                          title: 'Total Pengaduan',
                          value: controller.totalPengaduan.value,
                          icon: Icons.inbox_rounded,
                          color: AppColors.blue,
                        ),
                        _StatCard(
                          title: 'Pengaduan Baru',
                          value: controller.pengaduanBaru.value,
                          icon: Icons.fiber_new_rounded,
                          color: AppColors.warning,
                        ),
                        _StatCard(
                          title: 'Sedang Diproses',
                          value: controller.pengaduanDiproses.value,
                          icon: Icons.sync_rounded,
                          color: AppColors.blue,
                        ),
                        _StatCard(
                          title: 'Menunggu Persetujuan',
                          value: controller.menungguPersetujuan.value,
                          icon: Icons.fact_check_outlined,
                          color: AppColors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Menu Utama',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _MenuTile(
                      icon: Icons.assignment_outlined,
                      title: 'Pengelolaan Pengaduan',
                      subtitle: 'Periksa, kategorikan, dan delegasikan aduan',
                      onTap: () => Get.to(() => const AdminComplaintsView()),
                    ),
                    _MenuTile(
                      icon: Icons.apartment_rounded,
                      title: 'Instansi dan Unit',
                      subtitle: 'Kelola organisasi dan unit kerja',
                      onTap: () => _showComingSoon('Instansi dan Unit'),
                    ),
                    _MenuTile(
                      icon: Icons.people_alt_outlined,
                      title: 'Pengguna dan Hak Akses',
                      subtitle: 'Kelola admin unit dan petugas lapangan',
                      onTap: () => _showComingSoon('Pengguna'),
                    ),
                    _MenuTile(
                      icon: Icons.category_outlined,
                      title: 'Kategori Pengaduan',
                      subtitle: 'Kelola kategori dan klasifikasi pengaduan',
                      onTap: () => Get.to(() => AdminComplaintCategoriesView()),
                    ),
                    _MenuTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Profil Admin',
                      subtitle: 'Informasi dan pengaturan akun',
                      onTap: () => _showComingSoon('Profil'),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 25),
          Text(
            value.toString(),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 11),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.blueLight.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
