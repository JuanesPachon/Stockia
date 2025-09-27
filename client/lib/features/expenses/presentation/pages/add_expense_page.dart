import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../shared/widgets/default_dropdown.dart';
import '../../../../shared/widgets/default_textarea.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  int _currentBottomIndex = 1;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _selectedCategory = 'Comida';
  String _selectedProvider = 'No aplica';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
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
            'Gestión > Gastos > Agregar',
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
                      'Agregar nuevo gasto:',
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
                          label: 'Título del gasto:',
                          controller: _titleController,
                        ),

                        const SizedBox(height: 20),

                        DefaultTextField(
                          label: 'Monto:',
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 20),

                        DefaultDropdown(
                          label: 'Categoría:',
                          value: _selectedCategory,
                          items: const [
                            'Comida',
                            'Transporte',
                            'Servicios',
                            'Materiales',
                            'Personal',
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
                            'No aplica',
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

                        DefaultTextArea(
                          label: 'Descripción:',
                          controller: _descriptionController,
                          maxLines: 6,
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
                text: 'Agregar gasto', 
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