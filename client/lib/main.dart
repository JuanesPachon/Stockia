import 'package:client/features/management/presentation/pages/management_page.dart';
import 'package:client/features/notes/presentation/pages/notes_page.dart';
import 'package:client/features/products/presentation/pages/products_page.dart';
import 'package:client/features/sales/presentation/pages/sales_page.dart';
import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/pages/welcome_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/settings/presentation/pages/edit_account_page.dart';
import 'features/categories/presentation/pages/categories_page.dart';
import 'features/providers/presentation/pages/providers_page.dart';
import 'features/expenses/presentation/pages/expenses_page.dart';

void main() {
  runApp(const StockiaApp());
}

class StockiaApp extends StatelessWidget {
  const StockiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockia',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.dashboard,
      routes: {
        AppRoutes.welcome: (context) => const WelcomePage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.dashboard: (context) => const DashboardPage(),
        AppRoutes.management: (context) => const ManagementPage(),
        AppRoutes.settings: (context) => const SettingsPage(),
        AppRoutes.editAccount: (context) => const EditAccountPage(),
        AppRoutes.categories: (context) => const CategoriesPage(),
        AppRoutes.providers: (context) => const ProvidersPage(),
        AppRoutes.expenses: (context) => const ExpensesPage(),
        AppRoutes.notes: (context) => const NotesPage(),
        AppRoutes.products: (context) => const ProductsPage(),
        AppRoutes.sales: (context) => const SalesPage(),
      },
    );
  }
}
