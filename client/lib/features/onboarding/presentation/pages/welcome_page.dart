import 'package:client/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../shared/widgets/app_footer.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
              
                    Image.asset('assets/images/stockia_logo.png', height: 60),
              
                    SizedBox(height: screenHeight * 0.05),
              
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/images/onboarding_image.png',
                        fit: BoxFit.contain,
                      ),
                    ),
              
                    SizedBox(height: screenHeight * 0.05),
              
                    _buildTextContent(),
              
                    SizedBox(height: screenHeight * 0.04),
              
                    _buildButtons(context),
                  ],
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        const Text(
          'Manejo fácil del éxito de tu negocio',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.mainBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Controla todos los apartados necesarios para aumentar tu rentabilidad',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.mainBlue,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          text: 'Inicia ahora',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Ya tienes una cuenta?',
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 14.0,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
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
    );
  }
}
