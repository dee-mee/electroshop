import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

/// Login Screen for ElectroShop electrical retail mobile commerce application
/// Provides secure user authentication with multiple login options
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isSocialLoading = false;
  bool _isBiometricLoading = false;
  bool _isBiometricAvailable = false;
  String? _errorMessage;

  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'customer@electroshop.com': 'customer123',
    'owner@electroshop.com': 'owner123',
    'admin@electroshop.com': 'admin123',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(Duration(milliseconds: 200), () {
      _fadeAnimationController.forward();
    });

    Future.delayed(Duration(milliseconds: 400), () {
      _slideAnimationController.forward();
    });
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = !kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android);
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 1500));

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Check mock credentials
      if (_mockCredentials.containsKey(email) &&
          _mockCredentials[email] == password) {
        // Success haptic feedback
        if (!kIsWeb) {
          HapticFeedback.lightImpact();
        }

        // Navigate to dashboard
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/product-dashboard');
        }
      } else {
        // Invalid credentials
        setState(() {
          _errorMessage =
              'Invalid email or password. Please check your credentials.';
        });

        // Error haptic feedback
        if (!kIsWeb) {
          HapticFeedback.heavyImpact();
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Login failed. Please check your internet connection and try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    if (_isSocialLoading) return;

    setState(() {
      _isSocialLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate social login
      await Future.delayed(Duration(milliseconds: 2000));

      // Success haptic feedback
      if (!kIsWeb) {
        HapticFeedback.lightImpact();
      }

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/product-dashboard');
      }
    } catch (e) {
      setState(() {
        _errorMessage = '$provider login failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSocialLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    if (_isBiometricLoading) return;

    setState(() {
      _isBiometricLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(Duration(milliseconds: 1000));

      // Success haptic feedback
      if (!kIsWeb) {
        HapticFeedback.lightImpact();
      }

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/product-dashboard');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Biometric authentication failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBiometricLoading = false;
        });
      }
    }
  }

  void _navigateToSignUp() {
    // Navigate to sign up screen (placeholder)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign up feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8.h),

                    // App Logo Section
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: AppLogoWidget(
                        logoSize: 20.w,
                        showAppName: true,
                        appName: 'ElectroShop',
                      ),
                    ),

                    SizedBox(height: 6.h),

                    // Welcome Text
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Welcome Back!',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Sign in to access your electrical store',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Error Message
                    if (_errorMessage != null)
                      SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color:
                                theme.colorScheme.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.error
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'error',
                                color: theme.colorScheme.error,
                                size: 20.sp,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Login Form
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: LoginFormWidget(
                          onSubmit: _handleLogin,
                          isLoading: _isLoading,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Social Login Section
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SocialLoginWidget(
                          isLoading: _isSocialLoading,
                          onGoogleLogin: () => _handleSocialLogin('Google'),
                          onAppleLogin: () => _handleSocialLogin('Apple'),
                          onFacebookLogin: () => _handleSocialLogin('Facebook'),
                        ),
                      ),
                    ),

                    // Biometric Login Section
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: BiometricLoginWidget(
                          isBiometricAvailable: _isBiometricAvailable,
                          onBiometricLogin: _handleBiometricLogin,
                          isLoading: _isBiometricLoading,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Sign Up Link
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to electrical shopping? ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            GestureDetector(
                              onTap: _navigateToSignUp,
                              child: Text(
                                'Sign Up',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),
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