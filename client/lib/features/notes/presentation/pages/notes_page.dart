import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
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
  String _selectedCategory = 'Selecciona';

  final List<Map<String, String>> _notes = [
    {
      'id': '#3',
      'title': 'Problema x',
      'category': 'Urgente',
      'shortDescription': 'Se tiene que probar si se usa esto o esto...',
      'fullDescription': 'Se tiene que probar si se usa esto de manera inadecuada puede provocar que se tenga que seguir los siguientes pasos:',
    },
    {
      'id': '#4',
      'title': 'Reunión mensual',
      'category': 'Trabajo',
      'shortDescription': 'Recordar temas importantes a tratar...',
      'fullDescription': 'Recordar temas importantes a tratar en la reunión mensual del equipo de desarrollo y ventas.',
    },
    {
      'id': '#5',
      'title': 'Inventario bodega',
      'category': 'Inventario',
      'shortDescription': 'Verificar stock de productos principales...',
      'fullDescription': 'Verificar stock de productos principales en bodega y actualizar sistema con cantidades reales.',
    },
    {
      'id': '#6',
      'title': 'Capacitación personal',
      'category': 'Recursos Humanos',
      'shortDescription': 'Programar sesión de capacitación...',
      'fullDescription': 'Programar sesión de capacitación para el nuevo personal en procedimientos de atención al cliente.',
    },
  ];

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
            child: DefaultButton(text: 'Agregar Nota', onPressed: () {}),
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
                          if (newValue != null) {
                            setState(() {
                              _selectedFilter = newValue;
                            });
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

                      DropdownButton<String>(
                        value: _selectedCategory,
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
                            value: 'Selecciona',
                            child: Text('Selecciona'),
                          ),
                          DropdownMenuItem(
                            value: 'Urgente',
                            child: Text('Urgente'),
                          ),
                          DropdownMenuItem(
                            value: 'Trabajo',
                            child: Text('Trabajo'),
                          ),
                          DropdownMenuItem(
                            value: 'Inventario',
                            child: Text('Inventario'),
                          ),
                          DropdownMenuItem(
                            value: 'Recursos Humanos',
                            child: Text('Recursos Humanos'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
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

          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return NoteCard(
                  id: note['id']!,
                  title: note['title']!,
                  category: note['category']!,
                  description: note['shortDescription']!,
                  onDetailsPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailPage(
                          id: note['id']!,
                          title: note['title']!,
                          category: note['category']!,
                          description: note['fullDescription']!,
                        ),
                      ),
                    );
                  },
                  isEven: index % 2 == 0,
                );
              },
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