import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/modules/masyarakat/bindings/home_binding.dart';
import 'package:elingk/modules/masyarakat/controllers/home_controller.dart';
import 'package:elingk/modules/masyarakat/views/complaints/complaint_list_view.dart';
import 'package:elingk/modules/masyarakat/views/home/home_content.dart';
import 'package:elingk/modules/masyarakat/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;

  final List<Widget> pages = const [
    HomeContent(),
    ComplaintListView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();

    HomeBinding().dependencies();
    controller = Get.find<HomeController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: SafeArea(
            top: false,
            child: NavigationBar(
              selectedIndex: controller.currentIndex.value,
              onDestinationSelected: controller.changeTab,
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFFE8F1FF),
              elevation: 0,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment_rounded),
                  label: 'Pengaduan',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
