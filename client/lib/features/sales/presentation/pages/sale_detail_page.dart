import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/info_display_card.dart';
import '../../../../data/models/sale.dart';
import '../../../../data/models/product.dart';
import '../../../../data/services/product_service.dart';

class SaleDetailPage extends StatefulWidget {
  final Sale sale;

  const SaleDetailPage({super.key, required this.sale});

  @override
  State<SaleDetailPage> createState() => _SaleDetailPageState();
}

class _SaleDetailPageState extends State<SaleDetailPage> {
  int _currentBottomIndex = 1;
  final ProductService _productService = ProductService();
  Map<String, Product> _updatedProducts = {};
  bool _isLoadingProducts = false;

  @override
  void initState() {
    super.initState();
    _loadUpdatedProducts();
  }

  Future<void> _loadUpdatedProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      final response = await _productService.getProducts();

      if (mounted && response.success && response.data != null) {
        final Map<String, Product> productMap = {};
        for (var product in response.data!) {
          productMap[product.id] = product;
        }

        setState(() {
          _updatedProducts = productMap;
          _isLoadingProducts = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProducts = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
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
            'Ventas > Detalle',
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
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.mainBlue,
                      border: Border(
                        bottom: BorderSide(color: AppColors.mainBlue, width: 2),
                      ),
                    ),
                    child: Text(
                      'Venta #${widget.sale.id.substring(widget.sale.id.length - 6)}:',
                      style: const TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      InfoDisplayCard(
                        label: 'Fecha venta:',
                        value:
                            '${widget.sale.createdAt.day}/${widget.sale.createdAt.month}/${widget.sale.createdAt.year}',
                      ),

                      InfoDisplayCard(
                        label: 'Total:',
                        value: '\$${widget.sale.total.toStringAsFixed(0)}',
                      ),
                    ],
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.mainBlue,
                      border: Border(
                        top: BorderSide(color: AppColors.mainBlue, width: 2),
                        bottom: BorderSide(color: AppColors.mainBlue, width: 2),
                      ),
                    ),
                    child: const Text(
                      'Productos:',
                      style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  ...widget.sale.products.asMap().entries.map((entry) {
                    int index = entry.key;
                    var saleProduct = entry.value;
                    var product = saleProduct.product;

                    var updatedProduct =
                        _updatedProducts[product.id] ?? product;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? AppColors.mainWhite
                            : AppColors.mainBlue.withValues(alpha: 0.1),
                        border: const Border(
                          bottom: BorderSide(
                            color: AppColors.mainBlue,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.mainBlue,
                                width: 1,
                              ),
                              color: Colors.orange.shade300,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  updatedProduct.imageUrl != null &&
                                      updatedProduct.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      updatedProduct.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.orange.shade300,
                                              child: const Icon(
                                                Icons.fastfood,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            );
                                          },
                                    )
                                  : Container(
                                      color: Colors.orange.shade300,
                                      child: const Icon(
                                        Icons.fastfood,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  updatedProduct.name,
                                  style: const TextStyle(
                                    color: AppColors.mainBlue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Text(
                                      'Stock actual: ',
                                      style: const TextStyle(
                                        color: AppColors.mainBlue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    _isLoadingProducts
                                        ? const SizedBox(
                                            height: 12,
                                            width: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.mainBlue,
                                            ),
                                          )
                                        : Text(
                                            '${updatedProduct.stock}',
                                            style: TextStyle(
                                              color: updatedProduct.stock > 0
                                                  ? AppColors.mainBlue
                                                  : Colors.red,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Cantidad: ${saleProduct.quantity}',
                                style: const TextStyle(
                                  color: AppColors.mainBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                'Precio c/u: \$${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: AppColors.mainBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
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
}
