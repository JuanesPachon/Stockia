import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../widgets/provider_card.dart';
import 'provider_detail_page.dart';

class ProvidersPage extends StatefulWidget {
  const ProvidersPage({super.key});

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  int _currentBottomIndex = 1;
  String _selectedFilter = 'Mas recientes';
  String _selectedCategory = 'Selecciona';

  final List<Map<String, String>> _providers = [
    {
      'id': '#12',
      'name': 'Mc Donalds',
      'contact': '3126663556',
      'category': 'Comida',
      'status': 'Activo',
      'description': 'Proveedor de comida rápida especializado en hamburguesas, papas fritas y bebidas',
    },
    {
      'id': '#13',
      'name': 'Coca Cola',
      'contact': '3156789012',
      'category': 'Bebidas',
      'status': 'Activo',
      'description': 'Distribuidor oficial de bebidas carbonatadas y no carbonatadas de la marca Coca Cola',
    },
    {
      'id': '#14',
      'name': 'Limpieza Total',
      'contact': '3198765432',
      'category': 'Limpieza',
      'status': 'Inactivo',
      'description': 'Proveedor de productos de limpieza y aseo para uso doméstico y comercial',
    },
    {
      'id': '#15',
      'name': 'TechStore',
      'contact': '3147896325',
      'category': 'Electrónicos',
      'status': 'Activo',
      'description': 'Distribuidor de dispositivos electrónicos, componentes y accesorios tecnológicos',
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
          'Proveedores',
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
            child: DefaultButton(text: 'Agregar Proveedor', onPressed: () {}),
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
              itemCount: _providers.length,
              itemBuilder: (context, index) {
                final provider = _providers[index];
                return ProviderCard(
                  id: provider['id']!,
                  name: provider['name']!,
                  contact: provider['contact']!,
                  category: provider['category']!,
                  status: provider['status']!,
                  onDetailsPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProviderDetailPage(
                          id: provider['id']!,
                          name: provider['name']!,
                          contact: provider['contact']!,
                          category: provider['category']!,
                          status: provider['status']!,
                          description: provider['description']!,
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
