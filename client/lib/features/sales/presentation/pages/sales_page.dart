import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../widgets/sales_card.dart';
import 'sale_detail_page.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  int _currentBottomIndex = 1;
  String _selectedFilter = 'Mas recientes';

  final List<Map<String, dynamic>> _sales = [
    {
      'id': '#290',
      'date': '28-08-2025',
      'productsInfo': 'Café, Empanada + 4 productos...',
      'total': '\$100.000',
      'products': [
        {
          'name': 'Empanada',
          'quantity': '2',
          'stock': '13',
          'pricePerUnit': '\$1.000',
          'imageUrl': 'assets/images/empanada.png',
        },
        {
          'name': 'Café',
          'quantity': '3',
          'stock': '25',
          'pricePerUnit': '\$2.500',
          'imageUrl': 'assets/images/cafe.png',
        },
        {
          'name': 'Coca Cola',
          'quantity': '2',
          'stock': '50',
          'pricePerUnit': '\$3.500',
          'imageUrl': 'assets/images/coca_cola.png',
        },
      ],
    },
    {
      'id': '#289',
      'date': '28-08-2025',
      'productsInfo': 'Café, Empanada + 4 productos...',
      'total': '\$84.000',
      'products': [
        {
          'name': 'Empanada',
          'quantity': '1',
          'stock': '13',
          'pricePerUnit': '\$1.000',
          'imageUrl': 'assets/images/empanada.png',
        },
        {
          'name': 'Hamburguesa',
          'quantity': '2',
          'stock': '8',
          'pricePerUnit': '\$25.000',
          'imageUrl': 'assets/images/hamburguesa.png',
        },
      ],
    },
    {
      'id': '#291',
      'date': '28-08-2025',
      'productsInfo': 'Café, Empanada + 4 productos...',
      'total': '\$1.000.000',
      'products': [
        {
          'name': 'Empanada',
          'quantity': '5',
          'stock': '13',
          'pricePerUnit': '\$1.000',
          'imageUrl': 'assets/images/empanada.png',
        },
        {
          'name': 'Papas Fritas',
          'quantity': '3',
          'stock': '20',
          'pricePerUnit': '\$8.000',
          'imageUrl': 'assets/images/papas.png',
        },
      ],
    },
    {
      'id': '#292',
      'date': '27-08-2025',
      'productsInfo': 'Café, Empanada + 2 productos...',
      'total': '\$45.500',
      'products': [
        {
          'name': 'Coca Cola',
          'quantity': '4',
          'stock': '50',
          'pricePerUnit': '\$3.500',
          'imageUrl': 'assets/images/coca_cola.png',
        },
        {
          'name': 'Café',
          'quantity': '6',
          'stock': '25',
          'pricePerUnit': '\$2.500',
          'imageUrl': 'assets/images/cafe.png',
        },
      ],
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
          'Ventas',
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
            child: DefaultButton(text: 'Agregar venta', onPressed: () {}),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Container(
            decoration: const BoxDecoration(color: AppColors.mainBlue),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            ),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Expanded(
            child: ListView.builder(
              itemCount: _sales.length,
              itemBuilder: (context, index) {
                final sale = _sales[index];
                return SalesCard(
                  id: sale['id']!,
                  date: sale['date']!,
                  productsInfo: sale['productsInfo']!,
                  total: sale['total']!,
                  onDetailsPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaleDetailPage(
                          id: sale['id']!,
                          date: sale['date']!,
                          total: sale['total']!,
                          products: List<Map<String, String>>.from(
                            sale['products'].map((product) => Map<String, String>.from(product))
                          ),
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