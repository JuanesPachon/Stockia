import 'package:client/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/models/auth/login_request.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final loginRequest = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final response = await _authService.login(loginRequest);

      if (response.success) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.message?.toLowerCase() == 'invalid credentials'
                    ? 'Credenciales inválidas'
                    : 'Error inesperado. Intente nuevamente.',
              ),
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.1),

                    Image.asset('assets/images/stockia_logo.png', height: 60),

                    SizedBox(height: screenHeight * 0.05),

                    const Text(
                      '¡Inicia sesión!',
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
                          label: 'Email:',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        DefaultButton(
                          text: _isLoading
                              ? 'Iniciando sesión...'
                              : 'Iniciar sesión',
                          onPressed: _isLoading ? null : _handleLogin,
                        ),

                        SizedBox(height: 5),

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
                              '¿No tienes una cuenta?',
                              style: TextStyle(
                                color: AppColors.mainBlue,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                );
                              },
                              child: const Text(
                                'Regístrate aquí.',
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
      ),
    );
  }
}
