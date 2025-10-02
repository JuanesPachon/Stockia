import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/sale_service.dart';
import '../../../../data/models/sale.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../core/utils/currency_formatter.dart';
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
  final SaleService _saleService = SaleService();

  List<Sale> _sales = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final order = _selectedFilter == 'Mas recientes' ? 'desc' : 'asc';
      final response = await _saleService.getSales(order: order);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.data != null) {
            _sales = response.data!;
          } else {
            _errorMessage = response.error ?? 'Error al cargar ventas';
            _sales = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inesperado: $e';
          _sales = [];
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _getProductsInfo(List<SaleProductItem> products) {
    if (products.isEmpty) return 'Sin productos';
    
    if (products.length == 1) {
      return '${products.length} producto';
    }
    
    return '${products.length} productos';
  }

  Widget _buildSalesList() {
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
            Icon(Icons.error_outline, size: 64, color: Colors.red[800]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[800], fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadSales(),
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

    if (_sales.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_outlined, size: 64, color: AppColors.mainBlue),
            SizedBox(height: 16),
            Text(
              'No hay ventas registradas',
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Agrega tu primera venta.',
              style: TextStyle(color: AppColors.mainBlue, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _sales.length,
      itemBuilder: (context, index) {
        final sale = _sales[index];
        return SalesCard(
          id: '#${sale.id.substring(sale.id.length - 6)}',
          date: _formatDate(sale.createdAt),
          productsInfo: _getProductsInfo(sale.products),
          total: CurrencyFormatter.formatCOP(sale.total),
          onDetailsPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SaleDetailPage(
                  sale: sale,
                ),
              ),
            );
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
            child: DefaultButton(
              text: 'Agregar venta', 
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.addSale);
                if (result == true) {
                  _loadSales();
                }
              }
            ),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Container(
            decoration: const BoxDecoration(color: AppColors.mainBlue),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
                        _loadSales();
                      }
                    },
                    dropdownColor: AppColors.mainBlue,
                  ),
                ],
              ),
            ),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Expanded(child: _buildSalesList()),
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