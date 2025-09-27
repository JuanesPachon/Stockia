import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/info_display_card.dart';

class ExpenseDetailPage extends StatefulWidget {
  final String id;
  final String title;
  final String category;
  final String amount;
  final String provider;
  final String description;

  const ExpenseDetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.provider,
    required this.description,
  });

  @override
  State<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
  int _currentBottomIndex = 1;

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
            'Gestión > Gasto > ${widget.id}',
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
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.mainWhite,
                            size: 32,
                          ),
                          onPressed: () {
                            _showDeleteDialog();
                          },
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      InfoDisplayCard(
                        label: 'Id:',
                        value: widget.id,
                      ),

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
                text: 'Editar gasto', 
                onPressed: () {
                  // TODO: Implementar navegación a editar gasto
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
        return AlertDialog(
          backgroundColor: AppColors.mainWhite,
          title: const Text(
            'Eliminar Gasto',
            style: TextStyle(
              color: AppColors.mainBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar el gasto "${widget.title}"?',
            style: const TextStyle(
              color: AppColors.mainBlue,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.mainBlue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gasto eliminado exitosamente'),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}