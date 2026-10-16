import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_service.dart';
import 'login_view.dart';

class RolePlaceholderPage extends StatelessWidget {
  final String title;
  final String description;

  const RolePlaceholderPage({
    super.key,
    required this.title,
    required this.description,
  });

  Future<void> _logout() async {
    await AuthService().logout();
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
