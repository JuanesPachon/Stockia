import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../widgets/management_option_widget.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({super.key});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.mainBlue, width: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mainBlue),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.dashboard);
          },
        ),
        title: const Text(
          'Gestión',
          style: TextStyle(
            color: AppColors.mainBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.9,
            children: [
              ManagementOptionWidget(
                title: 'Ventas',
                iconPath: 'assets/icons/sales_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.sales);
                },
              ),
              ManagementOptionWidget(
                title: 'Productos',
                iconPath: 'assets/icons/products_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.products);
                },
              ),
              ManagementOptionWidget(
                title: 'Proveedores',
                iconPath: 'assets/icons/providers_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.providers);
                },
              ),
              ManagementOptionWidget(
                title: 'Gastos',
                iconPath: 'assets/icons/spends_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.expenses);
                },
              ),
              ManagementOptionWidget(
                title: 'Notas',
                iconPath: 'assets/icons/notes_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notes);
                },
              ),
              ManagementOptionWidget(
                title: 'Categorías',
                iconPath: 'assets/icons/categories_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.categories);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.settings);
              break;
          }
        },
      ),
    );
  }
}
