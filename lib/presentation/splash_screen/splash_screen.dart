import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_image_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _electricalController;
  late AnimationController _loadingController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _electricalOpacityAnimation;
  late Animation<double> _loadingRotationAnimation;

  String _loadingText = 'Initializing...';
  bool _isLoading = true;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitializationProcess();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _electricalController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Electrical effect animation controller
    _electricalController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Electrical effect opacity animation
    _electricalOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _electricalController,
      curve: Curves.easeInOut,
    ));

    // Loading rotation animation
    _loadingRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_loadingController);

    // Start animations
    _logoController.forward();

    Future.delayed(Duration(milliseconds: 800), () {
      _electricalController.repeat(reverse: true);
    });

    _loadingController.repeat();
  }

  void _startInitializationProcess() async {
    try {
      // Simulate initialization steps
      await _initializeStep('Loading app configuration...', 0.2);
      await _initializeStep('Checking network connectivity...', 0.4);
      await _initializeStep('Loading product categories...', 0.6);
      await _initializeStep('Checking authentication...', 0.8);
      await _initializeStep('Preparing electrical products...', 1.0);

      setState(() {
        _loadingText = 'Ready!';
        _isLoading = false;
      });

      // Wait a bit for the "Ready!" message to be visible
      await Future.delayed(Duration(milliseconds: 500));

      // Check authentication status and navigate accordingly
      _navigateToNextScreen();
    } catch (error) {
      setState(() {
        _loadingText = 'Initialization failed. Retrying...';
      });

      // Retry after a delay
      await Future.delayed(Duration(seconds: 2));
      _startInitializationProcess();
    }
  }

  Future<void> _initializeStep(String text, double progress) async {
    setState(() {
      _loadingText = text;
      _progress = progress;
    });

    // Simulate loading time
    await Future.delayed(Duration(milliseconds: 600));
  }

  void _navigateToNextScreen() {
    // Simulate authentication check
    bool isAuthenticated =
        false; // This should be replaced with real auth check

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.productDashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
              theme.colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section with Animation
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Opacity(
                            opacity: _logoOpacityAnimation.value,
                            child: Container(
                              width: 35.w,
                              height: 35.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Electrical Circuit Pattern
                                  AnimatedBuilder(
                                    animation: _electricalController,
                                    builder: (context, child) {
                                      return Opacity(
                                        opacity:
                                            _electricalOpacityAnimation.value *
                                                0.3,
                                        child: CustomPaint(
                                          size: Size(30.w, 30.w),
                                          painter: ElectricalCircuitPainter(
                                            theme.colorScheme.primary,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Logo Icon
                                  CustomIconWidget(
                                    iconName: 'electric_bolt',
                                    color: theme.colorScheme.primary,
                                    size: 15.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 8.h),

                    // Company Name
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: Column(
                            children: [
                              Text(
                                'ElectroShop',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Powering Your Electrical Needs',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
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

              // Loading Section
              Container(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  children: [
                    // Loading Indicator
                    AnimatedBuilder(
                      animation: _loadingController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _loadingRotationAnimation.value * 2 * 3.14159,
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                            child: CustomPaint(
                              painter: LoadingIndicatorPainter(
                                color: Colors.white,
                                progress: _progress,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Loading Text
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Text(
                        _loadingText,
                        key: ValueKey(_loadingText),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Progress Bar
                    Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: _progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Version Information
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  'Version 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for electrical circuit pattern
class ElectricalCircuitPainter extends CustomPainter {
  final Color color;

  ElectricalCircuitPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw circuit lines
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (math.pi / 180);
      final start = center +
          Offset(
            (radius * 0.7) * math.cos(angle),
            (radius * 0.7) * math.sin(angle),
          );
      final end = center +
          Offset(
            radius * math.cos(angle),
            radius * math.sin(angle),
          );

      canvas.drawLine(start, end, paint);

      // Draw small circles at the ends
      canvas.drawCircle(end, 2, paint..style = PaintingStyle.fill);
      paint.style = PaintingStyle.stroke;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Custom painter for loading indicator
class LoadingIndicatorPainter extends CustomPainter {
  final Color color;
  final double progress;

  LoadingIndicatorPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Progress arc
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}