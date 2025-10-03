import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/models/user.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../shared/widgets/default_button.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  int _currentBottomIndex = 2;
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  
  User? _user;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await _authService.getCurrentUser();
      if (response.success && response.data != null) {
        setState(() {
          _user = response.data;
          _nameController.text = _user?.name ?? '';
          _businessController.text = _user?.businessName ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
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
        title: const Text(
          'Ajustes > Editar',
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
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainBlue),
                    ),
                  )
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.mainBlue,
                      border: Border(
                        bottom: BorderSide(color: AppColors.mainBlue, width: 2),
                      ),
                    ),
                    child: const Text(
                      'Editar información:',
                      style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextField(
                            label: 'Nombre completo:',
                            controller: _nameController,
                            hintText: 'Ingresa tu nombre completo',
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El nombre es requerido';
                              }
                              if (value.length < 2 || value.length > 30) {
                                return 'El nombre debe tener entre 2 y 30 caracteres';
                              }
                              if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$').hasMatch(value)) {
                                return 'El nombre solo debe contener letras';
                              }
                              return null;
                            },
                          ),
                          
                          DefaultTextField(
                            label: 'Negocio:',
                            controller: _businessController,
                            hintText: '(opcional)',
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
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.mainBlue, width: 2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: DefaultButton(
                text: _isSaving ? 'Guardando...' : 'Confirmar edición', 
                onPressed: _isSaving ? null : _saveChanges,
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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final response = await _authService.updateUser(
        name: _nameController.text.trim(),
        businessName: _businessController.text.trim().isEmpty 
            ? null 
            : _businessController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        if (response.success) {
          showSuccessSnackBar(
            context,
            action: 'editó',
            resource: 'perfil',
            gender: 'el',
          );
          Navigator.pop(context, true);
        } else {
          String errorMessage = 'Error al actualizar el perfil, intente nuevamente.';

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
          _isSaving = false;
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
}