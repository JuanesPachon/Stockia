import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/provider_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/provider/provider.dart';
import '../../../../data/models/category/category.dart';
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
  String? _selectedCategoryId;
  final ProviderService _providerService = ProviderService();
  final CategoryService _categoryService = CategoryService();

  List<Provider> _providers = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  bool _isLoadingCategories = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProviders();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final response = await _categoryService.getCategories();

      if (mounted && response.success && response.data != null) {
        setState(() {
          _categories = response.data!;
          _isLoadingCategories = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingCategories = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final order = _selectedFilter == 'Mas recientes' ? 'desc' : 'asc';

      final response = await _providerService.getProviders(order: order);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.data != null) {
            List<Provider> allProviders = response.data!;

            if (_selectedCategoryId != null &&
                _selectedCategoryId!.isNotEmpty) {
              _providers = allProviders
                  .where((provider) => provider.categoryId == _selectedCategoryId)
                  .toList();
            } else {
              _providers = allProviders;
            }
          } else {
            _errorMessage = response.error ?? 'Error al cargar proveedores';
            _providers = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inesperado: $e';
          _providers = [];
        });
      }
    }
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return 'Sin categoría';

    final category = _categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Category(
        id: '',
        userId: '',
        name: 'Categoría desconocida',
        createdAt: DateTime.now(),
      ),
    );
    return category.name;
  }

  Widget _buildProvidersList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainBlue),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[800], fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadProviders(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainBlue,
                foregroundColor: AppColors.mainWhite,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_providers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined, size: 64, color: AppColors.mainBlue),
            SizedBox(height: 16),
            Text(
              'No hay proveedores disponibles',
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Agrega un proveedor o cambia el filtro.',
              style: TextStyle(color: AppColors.mainBlue, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _providers.length,
      itemBuilder: (context, index) {
        final provider = _providers[index];
        return ProviderCard(
          id: provider.id,
          name: provider.name,
          contact: provider.contact ?? 'Sin contacto',
          category: _getCategoryName(provider.categoryId),
          status: provider.status ? 'Activo' : 'Inactivo',
          onDetailsPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProviderDetailPage(
                  id: provider.id,
                  name: provider.name,
                  contact: provider.contact ?? 'Sin contacto',
                  category: _getCategoryName(provider.categoryId),
                  categoryId: provider.categoryId,
                  status: provider.status ? 'Activo' : 'Inactivo',
                  description: provider.description ?? 'Sin descripción',
                ),
              ),
            );
            if (result == true) {
              _loadProviders();
            }
          },
          isEven: index % 2 == 0,
        );
      },
    );
  }

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
            child: DefaultButton(
              text: 'Agregar Proveedor', 
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.addProvider);
                if (result == true) {
                  _loadProviders();
                }
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
                            _loadProviders();
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

                      _isLoadingCategories
                          ? Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                top: 14,
                                bottom: 14,
                              ),
                              child: Text(
                                'Cargando...',
                                style: TextStyle(color: AppColors.mainWhite),
                              ),
                            )
                          : DropdownButton<String>(
                              value: _selectedCategoryId,
                              underline: const SizedBox(),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.mainWhite,
                              ),
                              style: const TextStyle(
                                color: AppColors.mainWhite,
                                fontSize: 14,
                              ),
                              hint: const Text(
                                'Todas',
                                style: TextStyle(color: AppColors.mainWhite),
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Todas las categorías'),
                                ),
                                ..._categories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category.id,
                                    child: Text(category.name),
                                  );
                                }),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategoryId = newValue;
                                });
                                _loadProviders();
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

          Expanded(child: _buildProvidersList()),
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
