import 'package:elingk/app/routes/app_routes.dart';
import 'package:elingk/core/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_service.dart';
import 'login_view.dart';
import 'role_placeholder_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<_SessionResult> _session = _checkSession();

  bool _navigationStarted = false;

  Future<_SessionResult> _checkSession() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      return const _SessionResult.loggedOut();
    }

    try {
      final response = await AuthService().getMe();
      final role = _extractRole(response);

      return _SessionResult.authenticated(role);
    } catch (e) {
      debugPrint('AUTH GATE: gagal memeriksa sesi: $e');
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

    // Masyarakat tidak wajib memiliki role di database.
    if (roles is List && roles.isEmpty) {
      debugPrint('AUTH GATE: role kosong, diarahkan sebagai masyarakat.');
      return 'masyarakat';
    }

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

      final rawCode = item['kode'];
      if (rawCode == null) continue;

      final normalized = rawCode.toString().trim().toLowerCase().replaceAll(
        RegExp(r'[\s-]+'),
        '_',
      );

      final role = aliases[normalized] ?? normalized;

      debugPrint('AUTH GATE: role = $role');

      if (supportedRoles.contains(role)) {
        return role;
      }
    }

    debugPrint('AUTH GATE: role tidak dikenali.');
    return null;
  }

  String? _getDashboardRoute(String? role) {
    switch (role) {
      case 'masyarakat':
        return AppRoutes.home;

      case 'main_admin':
        return AppRoutes.adminUtama;

      case 'unit_admin':
        return AppRoutes.adminUnit;

      case 'field_officer':
        return AppRoutes.fieldOfficer;

      default:
        return null;
    }
  }

  void _navigateToDashboard(String route) {
    if (_navigationStarted) return;

    _navigationStarted = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Get.offAllNamed(route);
    });
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

        final route = _getDashboardRoute(session.role);

        if (route == null) {
          return const RolePlaceholderPage(
            title: 'Role belum dikenali',
            description:
                'Role akun belum ditemukan atau belum didukung. '
                'Periksa respons API /me.',
          );
        }

        _navigateToDashboard(route);

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
