import 'package:elingk/modules/admin_utama/views/dashboard/admin_utama_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/theme/app_theme.dart';
import 'core/storage/token_storage.dart';
import 'modules/auth/auth_service.dart';
import 'modules/auth/login_view.dart';
import 'modules/masyarakat/views/home/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ELingkApp());
}

class ELingkApp extends StatelessWidget {
  const ELingkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'eLingk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<_SessionResult> _session = _checkSession();

  Future<_SessionResult> _checkSession() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      return const _SessionResult.loggedOut();
    }

    try {
      final response = await AuthService().getMe();
      final role = _extractRole(response);

      return _SessionResult.authenticated(role);
    } catch (_) {
      await TokenStorage.deleteToken();
      return const _SessionResult.loggedOut();
    }
  }

  String? _extractRole(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map) return null;

    final user = data['user'];
    if (user is! Map) return null;

    final roles = user['roles'];
    if (roles is! List) return null;

    const aliases = {
      'admin_utama': 'main_admin',
      'admin_unit': 'unit_admin',
      'petugas_lapangan': 'field_officer',
    };

    const supportedRoles = {
      'masyarakat',
      'main_admin',
      'unit_admin',
      'field_officer',
    };

    for (final item in roles) {
      if (item is! Map) continue;

      // Prioritaskan kode role dari API Laravel.
      final rawCode = item['kode'];

      if (rawCode == null) continue;

      final normalized = rawCode.toString().trim().toLowerCase().replaceAll(
        RegExp(r'[\s-]+'),
        '_',
      );

      final role = aliases[normalized] ?? normalized;

      debugPrint('AUTH GATE: kode role API = $rawCode');
      debugPrint('AUTH GATE: role hasil normalisasi = $role');

      if (supportedRoles.contains(role)) {
        return role;
      }
    }

    debugPrint('AUTH GATE: tidak menemukan role yang didukung.');
    debugPrint('AUTH GATE: data roles = $roles');

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SessionResult>(
      future: _session,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const LoginView();
        }

        final session = snapshot.data!;

        if (!session.isAuthenticated) {
          return const LoginView();
        }

        switch (session.role) {
          case 'masyarakat':
            return const HomeView();

          case 'main_admin':
            return const AdminUtamaDashboardView();

          case 'unit_admin':
            return const RolePlaceholderPage(
              title: 'Admin Unit',
              description: 'Halaman Admin Unit siap dikembangkan.',
            );

          case 'field_officer':
            return const RolePlaceholderPage(
              title: 'Petugas Lapangan',
              description: 'Halaman Petugas Lapangan siap dikembangkan.',
            );

          default:
            return const RolePlaceholderPage(
              title: 'Role belum dikenali',
              description:
                  'Role akun belum ditemukan atau belum didukung. '
                  'Periksa respons API /me.',
            );
        }
      },
    );
  }
}

class _SessionResult {
  final bool isAuthenticated;
  final String? role;

  const _SessionResult._({required this.isAuthenticated, this.role});

  const _SessionResult.loggedOut() : this._(isAuthenticated: false);

  const _SessionResult.authenticated(String? role)
    : this._(isAuthenticated: true, role: role);
}

class RolePlaceholderPage extends StatelessWidget {
  final String title;
  final String description;

  const RolePlaceholderPage({
    super.key,
    required this.title,
    required this.description,
  });

  Future<void> _logout() async {
    try {
      await AuthService().logout();
    } catch (_) {
      // AuthService menghapus token lokal melalui finally.
    }

    Get.offAll(() => const LoginView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eLingk'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.admin_panel_settings_outlined, size: 64),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(description, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text(
                'Halaman ini masih dalam tahap pengembangan.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
