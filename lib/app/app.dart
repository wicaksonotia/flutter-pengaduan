import 'package:elingk/app/routes/app_pages.dart';
import 'package:elingk/modules/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'eLingk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      home: const AuthGate(),

      getPages: AppPages.pages,
    );
  }
}
