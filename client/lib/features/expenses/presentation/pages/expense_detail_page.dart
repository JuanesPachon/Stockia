import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/expense_service.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/info_display_card.dart';
import 'edit_expense_page.dart';

class ExpenseDetailPage extends StatefulWidget {
  final String id;
  final String title;
  final String category;
  final String? categoryId;
  final String amount;
  final String? providerId;
  final String provider;
  final String description;

  const ExpenseDetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    this.categoryId,
    required this.amount,
    this.providerId,
    required this.provider,
    required this.description,
  });

  @override
  State<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
  int _currentBottomIndex = 1;
  final ExpenseService _expenseService = ExpenseService();
  bool _isLoading = false;

  Future<void> _deleteExpense() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _expenseService.deleteExpense(widget.id);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          showSuccessSnackBar(
            context,
            action: 'eliminó',
            resource: 'gasto',
            gender: 'el',
            resourceName: widget.title,
          );
          Navigator.pop(context, true);
        } else {
          String errorMessage = 'Error al eliminar el gasto, intente nuevamente.';
          
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
            'Gastos > Detalle',
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
                          'Detalle del gasto:',
                          style: TextStyle(
                            color: AppColors.mainWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: _isLoading 
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainWhite),
                                    strokeWidth: 2,
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

                  Column(
                    children: [
                      InfoDisplayCard(
                        label: 'Título del gasto:',
                        value: widget.title,
                      ),

                      InfoDisplayCard(
                        label: 'Categoría:',
                        value: widget.category,
                      ),

                      InfoDisplayCard(
                        label: 'Monto:',
                        value: widget.amount,
                      ),

                      InfoDisplayCard(
                        label: 'Proveedor:',
                        value: widget.provider,
                      ),

                      InfoDisplayCard(
                        label: 'Descripción:',
                        value: widget.description,
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
                text: _isLoading ? 'Procesando...' : 'Editar gasto', 
                onPressed: _isLoading ? null : () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditExpensePage(
                        id: widget.id,
                        title: widget.title,
                        categoryId: widget.categoryId,
                        amount: double.tryParse(widget.amount.replaceAll('\$', '').replaceAll(',', '').replaceAll('.', '')) ?? 0.0,
                        providerId: widget.providerId,
                        description: widget.description,
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
          title: '¿Quieres eliminar este gasto?',
          message: widget.title,
          primaryButtonText: "Eliminar",
          secondaryButtonText: "Cancelar",
          onPrimaryPressed: () {
            Navigator.of(context).pop();
            _deleteExpense();
          },
          onSecondaryPressed: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}