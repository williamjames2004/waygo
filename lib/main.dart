import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/constants/app_routes.dart';

void main() {
  runApp(const WayGOApp());
}

class WayGOApp extends StatelessWidget {
  const WayGOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WayGO",

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}