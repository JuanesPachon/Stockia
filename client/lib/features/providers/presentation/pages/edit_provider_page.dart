import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../shared/widgets/default_dropdown.dart';
import '../../../../shared/widgets/default_textarea.dart';

class EditProviderPage extends StatefulWidget {
  final String id;
  final String name;
  final String contact;
  final String category;
  final String status;
  final String description;

  const EditProviderPage({
    super.key,
    required this.id,
    required this.name,
    required this.contact,
    required this.category,
    required this.status,
    required this.description,
  });

  @override
  State<EditProviderPage> createState() => _EditProviderPageState();
}

class _EditProviderPageState extends State<EditProviderPage> {
  int _currentBottomIndex = 1;
  
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _descriptionController;
  
  String _selectedCategory = 'Comida';
  String _selectedStatus = 'Activo';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _contactController = TextEditingController(text: widget.contact);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedCategory = widget.category;
    _selectedStatus = widget.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            'Gestión > Proveedores > Editar',
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
                    child: const Text(
                      'Editar proveedor:',
                      style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        DefaultTextField(
                          label: 'Nombre del proveedor:',
                          controller: _nameController,
                        ),

                        const SizedBox(height: 20),

                        DefaultDropdown(
                          label: 'Categoría:',
                          value: _selectedCategory,
                          items: const [
                            'Comida',
                            'Bebidas',
                            'Limpieza',
                            'Electrónicos',
                            'Materiales',
                            'Otros',
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        DefaultTextField(
                          label: 'Contacto:',
                          controller: _contactController,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Estado:',
                              style: TextStyle(
                                color: AppColors.mainBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Activo',
                                  groupValue: _selectedStatus,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedStatus = value;
                                      });
                                    }
                                  },
                                  activeColor: AppColors.mainBlue,
                                ),
                                const Text(
                                  'Activo',
                                  style: TextStyle(
                                    color: AppColors.mainBlue,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Radio<String>(
                                  value: 'Inactivo',
                                  groupValue: _selectedStatus,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedStatus = value;
                                      });
                                    }
                                  },
                                  activeColor: AppColors.mainBlue,
                                ),
                                const Text(
                                  'Inactivo',
                                  style: TextStyle(
                                    color: AppColors.mainBlue,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        DefaultTextArea(
                          label: 'Descripción:',
                          controller: _descriptionController,
                          maxLines: 5,
                        ),
                      ],
                    ),
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
                text: 'Confirmar edición', 
                onPressed: () {
                  final String providerName = _nameController.text.trim();
                  
                  showCustomDialog(
                    context,
                    title: 'Se ha editado el proveedor:',
                    message: '777 - ${providerName.isNotEmpty ? providerName : "Sin nombre"}',
                    showSecondaryButton: false,
                    primaryButtonText: "Aceptar",
                    onPrimaryPressed: () => {
                      Navigator.pop(context),
                      Navigator.pop(context),
                    },
                  );
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