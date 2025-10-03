import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/note_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/note/note.dart';
import '../../../../data/models/category/category.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../widgets/note_card.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  int _currentBottomIndex = 1;
  String _selectedFilter = 'Mas recientes';
  String? _selectedCategoryId;
  final NoteService _noteService = NoteService();
  final CategoryService _categoryService = CategoryService();

  List<Note> _notes = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  bool _isLoadingCategories = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadNotes();
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

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final order = _selectedFilter == 'Mas recientes' ? 'desc' : 'asc';

      final response = await _noteService.getNotes(order: order);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.data != null) {
            List<Note> allNotes = response.data!;

            if (_selectedCategoryId != null &&
                _selectedCategoryId!.isNotEmpty) {
              _notes = allNotes
                  .where((note) => note.categoryId == _selectedCategoryId)
                  .toList();
            } else {
              _notes = allNotes;
            }
          } else {
            _errorMessage = response.error ?? 'Error al cargar notas';
            _notes = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inesperado: $e';
          _notes = [];
        });
      }
    }
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return 'Sin categoría';

    final category = _categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Category(
        id: '',
        userId: '',
        name: 'Categoría desconocida',
        createdAt: DateTime.now(),
      ),
    );
    return category.name;
  }

  Widget _buildNotesList() {
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
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[800], fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotes,
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

    if (_notes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_outlined, size: 64, color: AppColors.mainBlue),
            SizedBox(height: 16),
            Text(
              'No hay notas disponibles',
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Agrega una nota o cambia el filtro',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mainBlue, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return NoteCard(
          id: note.id,
          title: note.title,
          category: _getCategoryName(note.categoryId),
          description: note.description.length > 50
              ? '${note.description.substring(0, 50)}...'
              : note.description,
          onDetailsPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailPage(
                  id: note.id,
                  title: note.title,
                  category: _getCategoryName(note.categoryId),
                  categoryId: note.categoryId,
                  description: note.description,
                ),
              ),
            );
            if (result == true) {
              _loadNotes();
            }
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
          'Notas',
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
              text: 'Agregar Nota',
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.addNote,
                );
                if (result == true) {
                  _loadNotes();
                }
              },
            ),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Container(
            decoration: const BoxDecoration(color: AppColors.mainBlue),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  Row(
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
                          if (newValue != null && newValue != _selectedFilter) {
                            setState(() {
                              _selectedFilter = newValue;
                            });
                            _loadNotes();
                          }
                        },
                        dropdownColor: AppColors.mainBlue,
                      ),
                    ],
                  ),

                  const Divider(
                    color: AppColors.mainWhite,
                    thickness: 2,
                    height: 0,
                  ),

                  Row(
                    children: [
                      const Text(
                        'Filtrar categoría:',
                        style: TextStyle(
                          color: AppColors.mainWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      _isLoadingCategories
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.mainWhite,
                                ),
                              ),
                            )
                          : DropdownButton<String>(
                              value: _selectedCategoryId,
                              underline: const SizedBox(),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.mainWhite,
                              ),
                              style: const TextStyle(
                                color: AppColors.mainWhite,
                                fontSize: 14,
                              ),
                              hint: const Text(
                                'Todas las categorías',
                                style: TextStyle(
                                  color: AppColors.mainWhite,
                                  fontSize: 14,
                                ),
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Todas las categorías', style: TextStyle()),
                                ),
                                ..._categories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category.id,
                                    child: Text(category.name, style: TextStyle()),
                                  );
                                }),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue != _selectedCategoryId) {
                                  setState(() {
                                    _selectedCategoryId = newValue;
                                  });
                                  _loadNotes();
                                }
                              },
                              dropdownColor: AppColors.mainBlue,
                            ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Expanded(child: _buildNotesList()),
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
