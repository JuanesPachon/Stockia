import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/provider_service.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/info_display_card.dart';
import 'edit_provider_page.dart';

class ProviderDetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String contact;
  final String category;
  final String? categoryId;
  final String status;
  final String description;

  const ProviderDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.contact,
    required this.category,
    this.categoryId,
    required this.status,
    required this.description,
  });

  @override
  State<ProviderDetailPage> createState() => _ProviderDetailPageState();
}

class _ProviderDetailPageState extends State<ProviderDetailPage> {
  int _currentBottomIndex = 1;
  final ProviderService _providerService = ProviderService();
  bool _isLoading = false;

  Future<void> _deleteProvider() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _providerService.deleteProvider(widget.id);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          showSuccessSnackBar(
            context,
            action: 'eliminó',
            resource: 'proveedor',
            gender: 'el',
            resourceName: widget.name,
          );
          Navigator.pop(context, true);
        } else {
          String errorMessage = 'Error al eliminar el proveedor, intente nuevamente.';
          
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
            'Proveedores > Detalle',
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
                          'Detalle proveedor :',
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
                                  title: '¿Quieres eliminar este proveedor?',
                                  message: widget.name,
                                  primaryButtonText: "Eliminar",
                                  secondaryButtonText: "Cancelar",
                                  onPrimaryPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteProvider();
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
                        label: 'Nombre del proveedor:',
                        value: widget.name,
                      ),

                      InfoDisplayCard(
                        label: 'Contacto:',
                        value: widget.contact,
                      ),

                      InfoDisplayCard(
                        label: 'Categoría:',
                        value: widget.category,
                      ),

                      InfoDisplayCard(
                        label: 'Estado:',
                        value: widget.status,
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
                text: _isLoading ? 'Procesando...' : 'Editar proveedor', 
                onPressed: _isLoading ? null : () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProviderPage(
                        id: widget.id,
                        name: widget.name,
                        contact: widget.contact,
                        categoryId: widget.categoryId,
                        status: widget.status == 'Activo',
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
}