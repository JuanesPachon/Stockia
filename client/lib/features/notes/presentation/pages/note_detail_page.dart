import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/note_service.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/info_display_card.dart';
import 'edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final String id;
  final String title;
  final String category;
  final String? categoryId;
  final String description;

  const NoteDetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    this.categoryId,
    required this.description,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  int _currentBottomIndex = 1;
  final NoteService _noteService = NoteService();
  bool _isLoading = false;

  Future<void> _deleteNote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _noteService.deleteNote(widget.id);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          showCustomDialog(
            context,
            title: 'Nota eliminada exitosamente',
            message: widget.title,
            showSecondaryButton: false,
            primaryButtonText: "Aceptar",
            onPrimaryPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
          );
        } else {
          String errorMessage = 'Error al eliminar la nota, intente nuevamente.';
          
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
            'Notas > Detalle',
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
                          'Detalle nota :',
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
                        label: 'Título de la nota:',
                        value: widget.title,
                      ),

                      InfoDisplayCard(
                        label: 'Categoría:',
                        value: widget.category,
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
                text: _isLoading ? 'Procesando...' : 'Editar nota', 
                onPressed: _isLoading ? null : () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNotePage(
                        id: widget.id,
                        title: widget.title,
                        categoryId: widget.categoryId,
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
          title: '¿Quieres eliminar esta nota?',
          message: widget.title,
          primaryButtonText: "Eliminar",
          secondaryButtonText: "Cancelar",
          onPrimaryPressed: () {
            Navigator.of(context).pop();
            _deleteNote();
          },
          onSecondaryPressed: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}