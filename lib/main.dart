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
  late final Future<bool> _checkSession = _isLoggedIn();

  Future<bool> _isLoggedIn() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      await AuthService().getMe();
      return true;
    } catch (_) {
      await TokenStorage.deleteToken();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkSession,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const HomeView();
        }

        return const LoginView();
      },
    );
  }
}
