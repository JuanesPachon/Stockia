import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'features/onboarding/presentation/pages/welcome_page.dart';

void main() {
  runApp(const StockiaApp());
}

class StockiaApp extends StatelessWidget {
  const StockiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockia',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => const WelcomePage(),
      },
    );
  }
}
