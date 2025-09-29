import 'package:client/shared/widgets/default_button.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/models/user.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/info_display_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentBottomIndex = 2;
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = true;

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

  String _getBusinessNameDisplay() {
    final businessName = _user?.businessName;
    if (businessName == null || businessName.isEmpty) {
      return 'No asignado';
    }
    return businessName;
  }

  void _logout() {
    setState(() {
      _user = null;
    });
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
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
            Navigator.pushNamed(context, AppRoutes.management);
          },
        ),
        title: const Text(
          'Ajustes',
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.mainBlue,
                            border: Border(
                              bottom: BorderSide(color: AppColors.mainBlue, width: 2),
                            ),
                          ),
                          child: const Text(
                            'Detalle de mi cuenta:',
                            style: TextStyle(
                              color: AppColors.mainWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        InfoDisplayCard(
                          label: 'Nombre completo:',
                          value: _user?.name ?? 'Cargando...',
                        ),
                        InfoDisplayCard(
                          label: 'Correo electrónico:',
                          value: _user?.email ?? 'Cargando...',
                        ),
                        InfoDisplayCard(
                          label: 'Negocio:',
                          value: _getBusinessNameDisplay(),
                        ),
                        
                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: DefaultButton(text: 'Editar cuenta',onPressed: () async {
                              final result = await Navigator.pushNamed(context, AppRoutes.editAccount);
                              if (result == true) {
                                _loadUserData();
                              }
                            },),
                          ),
                        ),

                        const SizedBox(height: 20),
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
                text: 'Cerrar sesión', 
                onPressed: _logout,
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
              // Already on settings page
              break;
          }
        },
      ),
    );
  }

}