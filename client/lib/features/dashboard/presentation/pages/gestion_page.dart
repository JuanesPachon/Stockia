import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../widgets/gestion_option_widget.dart';

class GestionPage extends StatefulWidget {
  const GestionPage({super.key});

  @override
  State<GestionPage> createState() => _GestionPageState();
}

class _GestionPageState extends State<GestionPage> {
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
            Navigator.pop(context);
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
            childAspectRatio: 1.1,
            children: [
              GestionOptionWidget(
                title: 'Ventas',
                iconPath: 'assets/icons/sales_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.sales);
                },
              ),
              GestionOptionWidget(
                title: 'Productos',
                iconPath: 'assets/icons/products_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.products);
                },
              ),
              GestionOptionWidget(
                title: 'Proveedores',
                iconPath: 'assets/icons/providers_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.providers);
                },
              ),
              GestionOptionWidget(
                title: 'Gastos',
                iconPath: 'assets/icons/spends_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.expenses);
                },
              ),
              GestionOptionWidget(
                title: 'Notas',
                iconPath: 'assets/icons/notes_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notes);
                },
              ),
              GestionOptionWidget(
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
