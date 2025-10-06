import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../shared/widgets/app_footer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _dotsMovementController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _loadingOpacity;
  
  final List<String> _motivationalPhrases = [
    '"Transformando tu negocio, un producto a la vez"',
    '"El control de tu inventario nunca fue tan fácil"',
    '"Digitalizando el futuro de tu emprendimiento"',
    '"Cada venta cuenta, cada producto importa"',
    '"Haciendo crecer tu negocio con inteligencia"',
  ];
  
  late String _currentPhrase;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _selectRandomPhrase();
    _startAnimations();
    _checkAuthStatus();
  }
  
  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _dotsMovementController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
    
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));
    
    _loadingOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));
  }
  
  void _selectRandomPhrase() {
    _currentPhrase = (_motivationalPhrases..shuffle()).first;
  }
  
  void _startAnimations() {
    _logoController.forward();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });
    
    if (mounted) {
      _dotsMovementController.repeat(reverse: true);
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _loadingController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _dotsMovementController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final hasSession = await _authService.hasActiveSession();
      
      if (hasSession) {
        final response = await _authService.getCurrentUser();
        
        if (mounted) {
          if (response.success) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          } else {
            await _authService.logout();
            Navigator.pushReplacementNamed(context, AppRoutes.welcome);
          }
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.welcome);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.mainWhite,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScale.value,
                    child: Opacity(
                      opacity: _logoOpacity.value,
                      child: Image.asset(
                        'assets/images/stockia_logo.png',
                        height: 120,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 10),
              
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textOpacity.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _currentPhrase,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.mainBlue.withValues(alpha: 0.8),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              AnimatedBuilder(
                animation: _loadingController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _loadingOpacity.value,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              final delay = index * 0.3;
                              return AnimatedBuilder(
                                animation: _dotsMovementController,
                                builder: (context, child) {
                                  double animationValue = _dotsMovementController.value - delay;
                                  if (animationValue < 0) animationValue = 0;
                                  if (animationValue > 1) animationValue = 1;
                                  
                                  final yOffset = -20 * (1 - (animationValue * 2 - 1).abs());
                                  
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Transform.translate(
                                      offset: Offset(0, yOffset),
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppColors.mainBlue.withValues(
                                            alpha: 0.8,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                        
                        Text(
                          'Preparando tu experiencia...',
                          style: TextStyle(
                            color: AppColors.mainBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
                  ],
                ),
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}