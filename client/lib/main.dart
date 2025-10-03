import 'package:flutter/material.dart';
import 'core/core.dart';
import 'features/features.dart';

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
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.welcome: (context) => const WelcomePage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.dashboard: (context) => const DashboardPage(),
        AppRoutes.management: (context) => const ManagementPage(),
        AppRoutes.settings: (context) => const SettingsPage(),
        AppRoutes.editAccount: (context) => const EditAccountPage(),
        AppRoutes.categories: (context) => const CategoriesPage(),
        AppRoutes.addCategory: (context) => const AddCategoryPage(),
        AppRoutes.providers: (context) => const ProvidersPage(),
        AppRoutes.addProvider: (context) => const AddProviderPage(),
        AppRoutes.expenses: (context) => const ExpensesPage(),
        AppRoutes.addExpense: (context) => const AddExpensePage(),
        AppRoutes.notes: (context) => const NotesPage(),
        AppRoutes.addNote: (context) => const AddNotePage(),
        AppRoutes.products: (context) => const ProductsPage(),
        AppRoutes.addProduct: (context) => const AddProductPage(),
        AppRoutes.sales: (context) => const SalesPage(),
        AppRoutes.addSale: (context) => const AddSalePage(),
      },
    );
  }
}
