import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int _currentBottomIndex = 1;
  String _selectedFilter = 'Mas recientes';
  String _selectedCategory = 'Selecciona';

  final List<Map<String, String>> _products = [
    {
      'id': '#777',
      'name': 'Empanada',
      'category': 'Comida',
      'provider': 'Mc Donalds',
      'stock': '150',
      'price': '\$100.000',
      'imageUrl': 'assets/images/empanada.png',
      'description': 'Empanada tradicional rellena de carne, pollo o queso, perfecta para cualquier ocasión',
    },
    {
      'id': '#778',
      'name': 'Hamburguesa',
      'category': 'Comida',
      'provider': 'Mc Donalds',
      'stock': '75',
      'price': '\$25.000',
      'imageUrl': 'assets/images/hamburguesa.png',
      'description': 'Hamburguesa clásica con carne de res, lechuga, tomate, cebolla y salsa especial',
    },
    {
      'id': '#779',
      'name': 'Coca Cola',
      'category': 'Bebidas',
      'provider': 'Coca Cola',
      'stock': '200',
      'price': '\$3.500',
      'imageUrl': 'assets/images/coca_cola.png',
      'description': 'Bebida carbonatada refrescante de 350ml, perfecta para acompañar cualquier comida',
    },
    {
      'id': '#780',
      'name': 'Papas Fritas',
      'category': 'Comida',
      'provider': 'Mc Donalds',
      'stock': '120',
      'price': '\$8.000',
      'imageUrl': 'assets/images/papas.png',
      'description': 'Papas fritas crujientes y doradas, sazonadas con sal marina',
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
          'Productos',
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
            child: DefaultButton(text: 'Agregar producto', onPressed: () {}),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Container(
            decoration: const BoxDecoration(color: AppColors.mainBlue),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  Row(
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
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.mainWhite,
                        ),
                        style: const TextStyle(
                          color: AppColors.mainWhite,
                          fontSize: 14,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Mas recientes',
                            child: Text('Mas recientes', style: TextStyle()),
                          ),
                          DropdownMenuItem(
                            value: 'Mas antiguos',
                            child: Text('Mas antiguos', style: TextStyle()),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedFilter = newValue;
                            });
                          }
                        },
                        dropdownColor: AppColors.mainBlue,
                      ),
                    ],
                  ),

                  const Divider(
                    color: AppColors.mainWhite,
                    thickness: 2,
                    height: 0,
                  ),

                  Row(
                    children: [
                      const Text(
                        'Filtrar categoría:',
                        style: TextStyle(
                          color: AppColors.mainWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      DropdownButton<String>(
                        value: _selectedCategory,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.mainWhite,
                        ),
                        style: const TextStyle(
                          color: AppColors.mainWhite,
                          fontSize: 14,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Selecciona',
                            child: Text('Selecciona'),
                          ),
                          DropdownMenuItem(
                            value: 'Comida',
                            child: Text('Comida'),
                          ),
                          DropdownMenuItem(
                            value: 'Bebidas',
                            child: Text('Bebidas'),
                          ),
                          DropdownMenuItem(
                            value: 'Limpieza',
                            child: Text('Limpieza'),
                          ),
                          DropdownMenuItem(
                            value: 'Electrónicos',
                            child: Text('Electrónicos'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
                        },
                        dropdownColor: AppColors.mainBlue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductCard(
                  id: product['id']!,
                  name: product['name']!,
                  category: product['category']!,
                  stock: product['stock']!,
                  price: product['price']!,
                  imageUrl: product['imageUrl']!,
                  onDetailsPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          id: product['id']!,
                          name: product['name']!,
                          category: product['category']!,
                          provider: product['provider']!,
                          stock: product['stock']!,
                          price: product['price']!,
                          description: product['description']!,
                          imageUrl: product['imageUrl']!,
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