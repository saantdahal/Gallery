import 'package:flutter/material.dart';
import 'package:gallery/core/routes/app_router.dart';
import 'package:gallery/core/theme/app_theme.dart';
import 'package:gallery/config/flavorizr/flavor_config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: FlavorConfig.title,
      theme: AppTheme.lightTheme,
      routerConfig: RouterConfiguration.router,
    );
  }
}
