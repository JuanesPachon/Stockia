import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/note_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/note/create_note_request.dart';
import '../../../../data/models/category.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';

import '../../../../shared/widgets/default_textarea.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  int _currentBottomIndex = 1;
  final _formKey = GlobalKey<FormState>();
  final NoteService _noteService = NoteService();
  final CategoryService _categoryService = CategoryService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingCategories = false;
  List<Category> _categories = [];
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final response = await _categoryService.getCategories();

      if (mounted && response.success && response.data != null) {
        setState(() {
          _categories = response.data!;
          _isLoadingCategories = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingCategories = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> _createNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateNoteRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId,
      );
      final response = await _noteService.createNote(request);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success && response.data != null) {
          final note = response.data!;
          showCustomDialog(
            context,
            title: 'Se ha agregado la nota:',
            message: note.title,
            showSecondaryButton: false,
            primaryButtonText: "Aceptar",
            onPrimaryPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
          );
        } else {
          String errorMessage = 'Error al crear la nota, intente nuevamente.';

          final error = response.error?.toLowerCase() ?? '';

          if (error.contains('duplicate')) {
            errorMessage = 'Ya existe una nota con ese título.';
          }

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
            'Gestión > Notas > Agregar',
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
                      'Agregar nueva nota:',
                      style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DefaultTextField(
                            label: 'Título de la nota:',
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Este campo es requerido';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _isLoadingCategories
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Categoría:',
                                        style: TextStyle(
                                          color: AppColors.mainBlue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.mainWhite,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppColors.mainBlue,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text('Cargando categorías...'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Categoría (opcional):',
                                      style: TextStyle(
                                        color: AppColors.mainBlue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.mainBlue,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                        child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedCategoryId,
                                          isExpanded: true,
                                          dropdownColor: AppColors.mainWhite,
                                          items: [
                                          const DropdownMenuItem<String>(
                                            value: null,
                                            child: Text('Sin categoría'),
                                          ),
                                          ..._categories.map((category) {
                                            return DropdownMenuItem<String>(
                                            value: category.id,
                                            child: Text(category.name, style: TextStyle(color: AppColors.mainBlue)),
                                            );
                                          }),
                                          ],
                                          onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedCategoryId = newValue;
                                          });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 20),

                          DefaultTextArea(
                            label: 'Descripción:',
                            controller: _descriptionController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Este campo es requerido';
                              }
                              return null;
                            },
                            maxLines: 6,
                          ),
                        ],
                      ),
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
                text: _isLoading ? 'Agregando...' : 'Agregar nota',
                onPressed: _isLoading ? null : _createNote,
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
