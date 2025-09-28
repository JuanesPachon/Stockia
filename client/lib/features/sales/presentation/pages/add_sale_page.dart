import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../widgets/product_sale_card.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({super.key});

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  int _currentBottomIndex = 1;
  
  String _selectedOrderBy = 'Mas recientes';
  String _selectedCategory = 'Selecciona';
  
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Empanada',
      'stock': 13,
      'price': 1000,
      'quantity': 0,
      'image': 'assets/images/empanada.jpg',
    },
    {
      'name': 'Empanada',
      'stock': 13,
      'price': 1000,
      'quantity': 0,
      'image': 'assets/images/empanada.jpg',
    },
    {
      'name': 'Empanada',
      'stock': 13,
      'price': 1000,
      'quantity': 0,
      'image': 'assets/images/empanada.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {

    double total = _products.fold(0.0, (sum, product) => sum + (product['price'] * product['quantity']));

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
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Gestión > Ventas > Agregar',
            style: const TextStyle(
              color: AppColors.mainBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.mainWhite,
              border: Border(
                bottom: BorderSide(color: AppColors.mainBlue, width: 2),
              ),
            ),
            child: const Text(
              'Productos:',
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

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
                        value: _selectedOrderBy,
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
                              _selectedOrderBy = newValue;
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
                return ProductSaleCard(
                  name: product['name'] ?? 'Producto',
                  stock: product['stock'] ?? 0,
                  price: (product['price'] ?? 0).toDouble(),
                  quantity: product['quantity'] ?? 0,
                  imageUrl: product['image'],
                  isEven: index % 2 == 0,
                  onIncrease: () {
                    setState(() {
                      if (product['quantity'] < product['stock']) {
                        product['quantity']++;
                      }
                    });
                  },
                  onDecrease: () {
                    setState(() {
                      if (product['quantity'] > 0) {
                        product['quantity']--;
                      }
                    });
                  },
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.mainBlue, width: 2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        color: AppColors.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DefaultButton(
                  text: 'Agregar venta',
                  onPressed: () {
                    
                    final double total = _products.fold(0.0, (sum, product) => sum + (product['price'] * product['quantity']));
                    
                    showCustomDialog(
                      context,
                      title: 'Se ha agregado la venta:',
                      message: '777 - Total: \$${total.toStringAsFixed(0)}',
                      primaryButtonText: "Aceptar",
                      onPrimaryPressed: () => {
                        Navigator.pop(context),
                        Navigator.pop(context),
                      },
                    );
                  },
                ),
              ],
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