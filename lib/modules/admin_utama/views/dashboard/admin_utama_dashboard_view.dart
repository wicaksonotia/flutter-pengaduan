import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/admin_utama/bindings/admin_utama_binding.dart';
import 'package:elingk/modules/admin_utama/controllers/admin_utama_controller.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_header.dart';
import 'package:elingk/modules/admin_utama/widgets/dashboard/admin_utama_menu_section.dart';
import 'package:elingk/modules/admin_utama/widgets/dashboard/admin_utama_stats_section.dart';
import 'package:elingk/modules/shared/widgets/dashboard/admin_welcome_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const AdminHeader(),
                  const SizedBox(height: 30),
                  const AdminWelcomeCard(),
                  const SizedBox(height: 27),
                  AdminUtamaStatsSection(controller: controller),
                  const SizedBox(height: 28),
                  const AdminUtamaMenuSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
