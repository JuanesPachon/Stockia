import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../widgets/category_card.dart';
import 'category_detail_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _currentBottomIndex = 1;
  String _selectedFilter = 'Mas recientes';

  final List<Map<String, String>> _categories = [
    {
      'id': '#8',
      'name': 'Comida',
      'fullName': '#8 Comida',
      'description': 'Categoría para todos los implementos relacionados a alimentos y demas cosas relacionadas',
      'date': '28-08-2025',
    },
    {
      'id': '#9',
      'name': 'Bebidas',
      'fullName': '#9 Bebidas',
      'description': 'Categoría para todos los tipos de bebidas y líquidos',
      'date': '27-08-2025',
    },
    {
      'id': '#10',
      'name': 'Limpieza',
      'fullName': '#10 Limpieza',
      'description': 'Categoría para productos de limpieza y aseo',
      'date': '26-08-2025',
    },
    {
      'id': '#11',
      'name': 'Electrónicos',
      'fullName': '#11 Electrónicos',
      'description': 'Categoría para dispositivos y componentes electrónicos',
      'date': '25-08-2025',
    },
  ];

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
          'Categorías',
          style: TextStyle(
            color: AppColors.mainBlue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: DefaultButton(
              text: 'Agregar categoría',
              onPressed: () {

              },
            ),
          ),

          const Divider(
            color: AppColors.mainBlue,
            thickness: 2,
            height: 0,
          ),
          
          Container(
            decoration: BoxDecoration(
              color: AppColors.mainBlue,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Text(
                    'Ordenar por :',
                    style: TextStyle(
                      color: AppColors.mainWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              
                  const Spacer(),
                  
                  DropdownButton<String>(
                    value: _selectedFilter,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.mainWhite),
                    style: const TextStyle(
                      color: AppColors.mainWhite,
                      fontSize: 14,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Mas recientes',
                        child: Text('Mas recientes'),
                      ),
                      DropdownMenuItem(
                        value: 'Mas antiguos',
                        child: Text('Mas antiguos'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedFilter = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const Divider(
            color: AppColors.mainBlue,
            thickness: 2,
            height: 0,
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryCard(
                  name: category['fullName']!,
                  description: category['description']!,
                  date: category['date']!,
                  onDetailsPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailPage(
                          id: category['id']!,
                          name: category['name']!,
                          description: category['description']!,
                        ),
                      ),
                    );
                  },
                  isEven: index % 2 == 0,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
          
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.management);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.settings);
              break;
          }
        },
      ),
    );
  }
}