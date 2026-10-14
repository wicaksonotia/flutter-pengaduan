import 'package:elingk/modules/admin_utama/views/dashboard/admin_utama_dashboard_view.dart';
import 'package:elingk/modules/masyarakat/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_service.dart';
import 'login_view.dart';

class AuthRedirectView extends StatefulWidget {
  const AuthRedirectView({super.key});

  @override
  State<AuthRedirectView> createState() => _AuthRedirectViewState();
}

class _AuthRedirectViewState extends State<AuthRedirectView> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    try {
      final response = await AuthService().getMe();
      if (!mounted) return;

      final role = _extractRole(response);

      switch (role) {
        case 'masyarakat':
          Get.offAll(() => const HomeView());
          break;

        case 'main_admin':
          Get.offAll(() => const AdminUtamaDashboardView());
          break;

        case 'unit_admin':
          Get.offAll(
            () => const _RolePlaceholder(
              title: 'Admin Unit',
              message: 'Halaman Admin Unit siap dikembangkan.',
            ),
          );
          break;

        case 'field_officer':
          Get.offAll(
            () => const _RolePlaceholder(
              title: 'Petugas Lapangan',
              message: 'Halaman Petugas Lapangan siap dikembangkan.',
            ),
          );
          break;

        default:
          Get.offAll(
            () => const _RolePlaceholder(
              title: 'Role belum dikenali',
              message:
                  'Role akun tidak ditemukan. Periksa respons endpoint /me.',
            ),
          );
      }
    } catch (_) {
      Get.offAll(() => const LoginView());
    }
  }

  String? _extractRole(Map<String, dynamic> response) {
    dynamic data = response;

    for (var i = 0; i < 5 && data is Map; i++) {
      final map = Map<String, dynamic>.from(data);

      final rawRoles = map['roles'];
      final rawRole = map['role'];

      final candidates = [
        ?rawRole,
        if (rawRoles is List) ...rawRoles,
        if (rawRoles != null && rawRoles is! List) rawRoles,
      ];

      for (final item in candidates) {
        String? value;

        if (item is String) {
          value = item;
        } else if (item is Map) {
          value =
              (item['kode'] ??
                      item['slug'] ??
                      item['name'] ??
                      item['nama'] ??
                      item['key'] ??
                      '')
                  .toString();
        }

        if (value == null) continue;

        final normalized = value.trim().toLowerCase().replaceAll(
          RegExp(r'[\s-]+'),
          '_',
        );

        const aliases = {
          'admin_utama': 'main_admin',
          'admin_unit': 'unit_admin',
          'petugas_lapangan': 'field_officer',
        };

        final role = aliases[normalized] ?? normalized;

        const supportedRoles = {
          'masyarakat',
          'main_admin',
          'unit_admin',
          'field_officer',
        };

        if (supportedRoles.contains(role)) {
          return role;
        }
      }

      if (map['user'] is Map) {
        data = map['user'];
      } else if (map['data'] is Map) {
        data = map['data'];
      } else {
        break;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _RolePlaceholder extends StatelessWidget {
  final String title;
  final String message;

  const _RolePlaceholder({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eLingk'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.admin_panel_settings_outlined, size: 60),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
