import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/models/auth/register_request.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final registerRequest = RegisterRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final response = await _authService.register(registerRequest);

      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cuenta creada exitosamente'),
              backgroundColor: Colors.green[800],
            ),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      } else {
        if (mounted) {
          
          String errorMessage = 'Error al crear la cuenta';
          if (response.error == 'duplicate') {
            errorMessage = 'Ya existe una cuenta con este email';
          } else if (response.error?.toLowerCase().contains('network') == true) {
            errorMessage = 'Error de conexión. Verifica tu internet.';
          } else if (response.error?.toLowerCase().contains('timeout') == true) {
            errorMessage = 'Tiempo de espera agotado. Intenta nuevamente.';
          } else {
            errorMessage = 'Error al crear la cuenta, intentalo de nuevo mas tarde';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado. Intente nuevamente.'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),
          
                  Image.asset('assets/images/stockia_logo.png', height: 60),
          
                  SizedBox(height: screenHeight * 0.05),
          
                  const Text(
                    '¡Regístrate!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.mainBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          
                  SizedBox(height: screenHeight * 0.05),
          
                  Column(
                    spacing: 15,
                    children: [
                      DefaultTextField(
                        label: 'Nombre completo:',
                        controller: _nameController,
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
                        label: 'Email:',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El email es requerido';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Por favor ingrese un email válido';
                          }
                          if (value.length > 100) {
                            return 'El email no debe exceder 100 caracteres';
                          }
                          return null;
                        },
                      ),
          
                      DefaultTextField(
                        label: 'Contraseña:',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.mainBlue,
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La contraseña es requerida';
                          }
                          if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$').hasMatch(value)) {
                            return 'La contraseña debe tener mínimo 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
                          }
                          
                          return null;
                        },
                      ),
          
                      const SizedBox(height: 5),
          
                        DefaultButton(
                          text: _isLoading ? 'Creando cuenta...' : 'Crear cuenta',
                          onPressed: _isLoading ? null : _handleRegister,
                        ),
          
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.mainBlue.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Text(
                              'o',
                              style: TextStyle(
                                color: AppColors.mainBlue.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.mainBlue.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
          
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿Ya tienes una cuenta?',
                            style: TextStyle(
                              color: AppColors.mainBlue,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, AppRoutes.login);
                            },
                            child: const Text(
                              'Inicia Sesión aquí.',
                              style: TextStyle(
                                color: AppColors.mainBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          
                  const Spacer(),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}