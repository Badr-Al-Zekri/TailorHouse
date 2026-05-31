import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailorhouse/src/core/di/injection.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize dependencies
  await initializeDependencies();

  runApp(const TailorHouseApp());
}

/// Main application widget
class TailorHouseApp extends StatelessWidget {
  const TailorHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TailorHouse',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,

      // Router configuration
      routerConfig: AppRouter.router,

      // Builder for global overlays
      builder: (context, child) {
        return MediaQuery(
          // Prevent text scaling issues
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
