import 'package:client/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: AppColors.mainBlue,
      child: Text(
      '© 2025 Stockia. Todos los derechos reservados',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.mainWhite,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      ),
    );
  }
}