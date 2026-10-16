import 'package:elingk/modules/admin_unit/views/dashboard/admin_unit_dashboard_view.dart';
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
      debugPrint('=== AUTH REDIRECT DIMULAI ===');

      final response = await AuthService().getMe();

      debugPrint('AUTH REDIRECT: respons diterima');
      debugPrint('AUTH REDIRECT: response = $response');
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
          Get.offAll(() => const AdminUnitDashboardView());
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
    final data = response['data'];
    if (data is! Map) return null;

    final user = data['user'];
    if (user is! Map) return null;

    final roles = user['roles'];

    if (roles is! List) {
      return null;
    }

    const supportedRoles = {
      'masyarakat',
      'main_admin',
      'unit_admin',
      'field_officer',
    };

    const aliases = {
      'admin_utama': 'main_admin',
      'admin_unit': 'unit_admin',
      'petugas_lapangan': 'field_officer',
    };

    for (final item in roles) {
      if (item is! Map) continue;

      final rawCode = item['kode'] ?? item['slug'] ?? item['key'];

      if (rawCode == null) continue;

      final normalized = rawCode.toString().trim().toLowerCase().replaceAll(
        RegExp(r'[\s-]+'),
        '_',
      );

      final role = aliases[normalized] ?? normalized;

      if (supportedRoles.contains(role)) {
        debugPrint('Role berhasil dikenali: $role');
        return role;
      }
    }

    debugPrint('Role tidak dikenali. Data roles: $roles');
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
