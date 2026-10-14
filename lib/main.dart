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
    final recognizedRoles = <String>{
      'masyarakat',
      'main_admin',
      'unit_admin',
      'field_officer',
    };

    String? normalize(dynamic value) {
      if (value is! String || value.trim().isEmpty) {
        return null;
      }

      final role = value.trim().toLowerCase().replaceAll(
        RegExp(r'[\s-]+'),
        '_',
      );

      const aliases = {
        'admin_utama': 'main_admin',
        'admin_unit': 'unit_admin',
        'petugas_lapangan': 'field_officer',
      };

      final normalized = aliases[role] ?? role;

      return recognizedRoles.contains(normalized) ? normalized : null;
    }

    String? readRoleValue(dynamic value) {
      if (value is String) {
        return normalize(value);
      }

      if (value is Map) {
        final map = Map<String, dynamic>.from(value);

        for (final key in ['slug', 'name', 'key', 'role']) {
          final result = normalize(map[key]);
          if (result != null) return result;
        }

        return null;
      }

      if (value is List) {
        for (final item in value) {
          final result = readRoleValue(item);
          if (result != null) return result;
        }
      }

      return null;
    }

    String? search(dynamic value, {int depth = 0}) {
      if (depth > 5 || value is! Map) return null;

      final map = Map<String, dynamic>.from(value);

      // Role bisa berupa string, objek, atau daftar role.
      for (final key in ['role', 'roles']) {
        if (map.containsKey(key)) {
          final result = readRoleValue(map[key]);
          if (result != null) return result;
        }
      }

      // Periksa bentuk respons API yang umum.
      for (final key in ['user', 'data', 'result', 'profile']) {
        final nested = map[key];

        if (nested is Map) {
          final result = search(nested, depth: depth + 1);
          if (result != null) return result;
        }
      }

      return null;
    }

    return search(response);
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
            return const RolePlaceholderPage(
              title: 'Admin Utama',
              description: 'Halaman Admin Utama siap dikembangkan.',
            );

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
