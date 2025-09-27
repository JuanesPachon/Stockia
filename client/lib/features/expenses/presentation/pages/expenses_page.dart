import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../widgets/expense_card.dart';
import 'expense_detail_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  int _currentBottomIndex = 1;
  String _selectedFilter = 'Mas recientes';
  String _selectedCategory = 'Selecciona';

  final List<Map<String, String>> _expenses = [
    {
      'id': '#12',
      'title': 'Materia prima',
      'description': 'Se compraron 15 bultos de...',
      'category': 'Comida',
      'amount': '\$150.500',
      'date': '28-08-2025',
      'provider': 'Mc Donalds',
      'fullDescription': 'Se compraron 15 bultos de maíz molido para poder desarrollar los productos.',
    },
    {
      'id': '#13',
      'title': 'Insumos oficina',
      'description': 'Compra de material de oficina...',
      'category': 'Oficina',
      'amount': '\$75.200',
      'date': '27-08-2025',
      'provider': 'TechStore',
      'fullDescription': 'Compra de material de oficina para el funcionamiento diario de la empresa.',
    },
    {
      'id': '#14',
      'title': 'Productos de limpieza',
      'description': 'Adquisición de productos de aseo...',
      'category': 'Limpieza',
      'amount': '\$45.800',
      'date': '26-08-2025',
      'provider': 'Limpieza Total',
      'fullDescription': 'Adquisición de productos de aseo y limpieza para mantener las instalaciones.',
    },
    {
      'id': '#15',
      'title': 'Bebidas para evento',
      'description': 'Compra de bebidas para evento...',
      'category': 'Bebidas',
      'amount': '\$120.300',
      'date': '25-08-2025',
      'provider': 'Coca Cola',
      'fullDescription': 'Compra de bebidas para evento corporativo del mes de agosto.',
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
          'Gastos',
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
              text: 'Agregar gastos', 
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addExpense);
              }
            ),
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
                            value: 'Oficina',
                            child: Text('Oficina'),
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
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return ExpenseCard(
                  id: expense['id']!,
                  title: expense['title']!,
                  description: expense['description']!,
                  category: expense['category']!,
                  amount: expense['amount']!,
                  date: expense['date']!,
                  onDetailsPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseDetailPage(
                          id: expense['id']!,
                          title: expense['title']!,
                          category: expense['category']!,
                          amount: expense['amount']!,
                          provider: expense['provider']!,
                          description: expense['fullDescription']!,
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