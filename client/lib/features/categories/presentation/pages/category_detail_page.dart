import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/category/category.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/info_display_card.dart';
import 'edit_category_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryId;

  const CategoryDetailPage({
    super.key,
    required this.categoryId,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  int _currentBottomIndex = 1;
  final CategoryService _categoryService = CategoryService();
  
  Category? _category;
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadCategoryDetail();
  }

  Future<void> _loadCategoryDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _categoryService.getCategoryById(widget.categoryId);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.data != null) {
            _category = response.data;
          } else {
            _errorMessage = response.error ?? 'Error al cargar la categoría';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inesperado: $e';
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Future<void> _deleteCategory() async {
    if (_category == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _categoryService.deleteCategory(_category!.id);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          showCustomDialog(
            context,
            title: 'Categoría eliminada exitosamente',
            message: _category!.name,
            showSecondaryButton: false,
            primaryButtonText: "Aceptar",
            onPrimaryPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
          );
        } else {
          String errorMessage = 'Error al eliminar la categoría, intente nuevamente.';
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red[800],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    }
  }

  Widget _buildBody() {
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
                color: Colors.red[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategoryDetail,
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

    if (_category == null) {
      return const Center(
        child: Text(
          'Categoría no encontrada',
          style: TextStyle(
            color: AppColors.mainBlue,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.mainBlue,
                    border: Border(
                      bottom: BorderSide(color: AppColors.mainBlue, width: 2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detalle categoría:',
                        style: TextStyle(
                          color: AppColors.mainWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.mainWhite,
                          size: 32,
                        ),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                title: '¿Quieres eliminar esta categoría?',
                                message: _category!.name,
                                primaryButtonText: "Eliminar",
                                secondaryButtonText: "Cancelar",
                                onPrimaryPressed: () {
                                  Navigator.of(context).pop();
                                  _deleteCategory();
                                },
                                onSecondaryPressed: () => Navigator.of(context).pop(),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    InfoDisplayCard(
                      label: 'Nombre de la categoría:',
                      value: _category!.name,
                    ),
                    InfoDisplayCard(
                      label: 'Descripción:',
                      value: _category!.description ?? 'Sin descripción',
                    ),
                    InfoDisplayCard(
                      label: 'Fecha de creación:',
                      value: _formatDate(_category!.createdAt),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.mainBlue, width: 2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: DefaultButton(
              text: 'Editar categoría',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCategoryPage(
                      id: _category!.id,
                      name: _category!.name,
                      description: _category!.description ?? '',
                    ),
                  ),
                );
                if (result == true) {
                  _hasChanges = true; 
                  _loadCategoryDetail();
                }
              },
            ),
          ),
        ),
      ],
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
            Navigator.pop(context, _hasChanges); 
          },
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Categorías > Detalle',
            style: const TextStyle(
              color: AppColors.mainBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: _buildBody(),
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
