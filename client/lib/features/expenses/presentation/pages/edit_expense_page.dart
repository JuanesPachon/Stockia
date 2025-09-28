import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../shared/widgets/default_dropdown.dart';
import '../../../../shared/widgets/default_textarea.dart';

class EditExpensePage extends StatefulWidget {
  final String id;
  final String title;
  final String category;
  final String amount;
  final String provider;
  final String description;

  const EditExpensePage({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.provider,
    required this.description,
  });

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  int _currentBottomIndex = 1;
  
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  
  String _selectedCategory = 'Comida';
  String _selectedProvider = 'No aplica';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _amountController = TextEditingController(text: widget.amount);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedCategory = widget.category;
    _selectedProvider = widget.provider;
  }

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
            'Gestión > Gastos > Editar',
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
                      'Editar gasto:',
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

                        DefaultDropdown(
                          label: 'Categoría:',
                          value: _selectedCategory,
                          items: const [
                            'Comida',
                            'Transporte',
                            'Servicios',
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
                          label: 'Monto:',
                          controller: _amountController,
                          keyboardType: TextInputType.number,
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
                  final String expenseTitle = _titleController.text.trim();
                  
                  showCustomDialog(
                    context,
                    title: 'Se ha editado el gasto:',
                    message: '777 - ${expenseTitle.isNotEmpty ? expenseTitle : "Sin título"}',
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