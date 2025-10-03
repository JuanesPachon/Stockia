import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/category/category.dart';
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
  final CategoryService _categoryService = CategoryService();
  
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final order = _selectedFilter == 'Mas recientes' ? 'desc' : 'asc';
      
      final response = await _categoryService.getCategories(order: order);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.data != null) {
            _categories = response.data!;
          } else {
            _errorMessage = response.error ?? 'Error al cargar categorías';
            _categories = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inesperado: $e';
          _categories = [];
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Widget _buildCategoriesList() {
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[800],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategories,
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

    if (_categories.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: AppColors.mainBlue,
            ),
            SizedBox(height: 16),
            Text(
              'No hay categorías disponibles',
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Agrega una categoría o cambia el filtro',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return CategoryCard(
          name: category.name,
          description: category.description ?? 'Sin descripción',
          date: _formatDate(category.createdAt),
          onDetailsPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailPage(
                  categoryId: category.id,
                ),
              ),
            );
            if (result == true) {
              _loadCategories(); 
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
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.addCategory);
                if (result == true) {
                  _loadCategories(); 
                }
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
                      if (newValue != null && newValue != _selectedFilter) {
                        setState(() {
                          _selectedFilter = newValue;
                        });
                        _loadCategories();
                      }
                    },
                    dropdownColor: AppColors.mainBlue,
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
            child: _buildCategoriesList(),
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