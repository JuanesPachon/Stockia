import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/product_service.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/info_display_card.dart';
import '../../../../shared/widgets/product_image.dart';
import 'edit_product_page.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String category;
  final String? categoryId;
  final String provider;
  final String? providerId;
  final String stock;
  final String price;
  final String? imageUrl;

  const ProductDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    this.categoryId,
    required this.provider,
    this.providerId,
    required this.stock,
    required this.price,
    this.imageUrl,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentBottomIndex = 1;
  final ProductService _productService = ProductService();
  bool _isLoading = false;

  Future<void> _deleteProduct() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _productService.deleteProduct(widget.id);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          showSuccessSnackBar(
            context,
            action: 'eliminó',
            resource: 'producto',
            gender: 'el',
            resourceName: widget.name,
          );
          Navigator.pop(context, true);
        } else {
          String errorMessage = 'Error al eliminar el producto, intente nuevamente.';
          
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
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Productos > Detalle',
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
                          'Detalle producto :',
                          style: TextStyle(
                            color: AppColors.mainWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: _isLoading 
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainWhite),
                                  ),
                                )
                              : const Icon(
                                  Icons.delete,
                                  color: AppColors.mainWhite,
                                  size: 32,
                                ),
                          onPressed: _isLoading ? null : () {
                            _showDeleteDialog();
                          },
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.mainWhite,
                      border: Border(
                        bottom: BorderSide(color: AppColors.mainBlue, width: 1),
                      ),
                    ),
                    child: Center(
                      child: ProductImage(
                        imageUrl: widget.imageUrl,
                        width: 150,
                        height: 150,
                        borderRadius: 12,
                        fallbackIcon: Icons.inventory,
                        fallbackIconSize: 60,
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      InfoDisplayCard(
                        label: 'Nombre del producto:',
                        value: widget.name,
                      ),

                      InfoDisplayCard(
                        label: 'Categoría:',
                        value: widget.category,
                      ),

                      InfoDisplayCard(
                        label: 'Proveedor:',
                        value: widget.provider,
                      ),

                      InfoDisplayCard(
                        label: 'Stock:',
                        value: widget.stock,
                      ),

                      InfoDisplayCard(
                        label: 'Precio c/u:',
                        value: '\$${widget.price}',
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
                text: _isLoading ? 'Procesando...' : 'Editar producto', 
                onPressed: _isLoading ? null : () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductPage(
                        id: widget.id,
                        name: widget.name,
                        category: widget.category,
                        categoryId: widget.categoryId,
                        provider: widget.provider,
                        providerId: widget.providerId,
                        stock: widget.stock,
                        price: widget.price,
                        imageUrl: widget.imageUrl,
                      ),
                    ),
                  );
                  if (result == true) {
                    Navigator.pop(context, true);
                  }
                },
              ),
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: '¿Quieres eliminar este producto?',
          message: widget.name,
          primaryButtonText: "Eliminar",
          secondaryButtonText: "Cancelar",
          onPrimaryPressed: () {
            Navigator.of(context).pop();
            _deleteProduct();
          },
          onSecondaryPressed: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}