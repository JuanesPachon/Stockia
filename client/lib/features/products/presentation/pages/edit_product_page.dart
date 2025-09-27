import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../shared/widgets/default_dropdown.dart';
import '../../../../shared/widgets/default_textarea.dart';

class EditProductPage extends StatefulWidget {
  final String id;
  final String name;
  final String category;
  final String provider;
  final String stock;
  final String price;
  final String description;
  final String imageUrl;

  const EditProductPage({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.provider,
    required this.stock,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  int _currentBottomIndex = 1;
  
  late TextEditingController _nameController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  
  String _selectedCategory = 'Comida';
  String _selectedProvider = 'Mc Donalds';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _stockController = TextEditingController(text: widget.stock);
    _priceController = TextEditingController(text: widget.price);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedCategory = widget.category;
    _selectedProvider = widget.provider;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
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
            'Gestión > Productos > Editar',
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
                      'Editar producto:',
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
                          label: 'Nombre del producto:',
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

                        DefaultDropdown(
                          label: 'Proveedor:',
                          value: _selectedProvider,
                          items: const [
                            'Mc Donalds',
                            'Coca Cola',
                            'Limpieza Total',
                            'TechStore',
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedProvider = newValue;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        DefaultTextField(
                          label: 'Stock:',
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 20),

                        DefaultTextField(
                          label: 'Precio c/u:',
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Imagen del producto:',
                              style: TextStyle(
                                color: AppColors.mainBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 205, 187, 152),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.mainBlue,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.image,
                                    color: AppColors.mainBlue,
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {

                                    },
                                    child: const Text(
                                      'Seleccionar',
                                      style: TextStyle(
                                        color: AppColors.mainBlue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        DefaultTextArea(
                          label: 'Descripción:',
                          controller: _descriptionController,
                          maxLines: 4,
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