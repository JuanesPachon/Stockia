import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.mainBlue,
        selectedItemColor: AppColors.mainWhite,
        unselectedItemColor: AppColors.mainWhite.withValues(alpha: 0.6),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, size: 40),
            label: 'Gestión',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 40),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
