import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Biometric login widget providing Face ID, Touch ID, and fingerprint authentication
class BiometricLoginWidget extends StatefulWidget {
  /// Whether biometric authentication is available
  final bool isBiometricAvailable;

  /// Callback when biometric login is tapped
  final VoidCallback onBiometricLogin;

  /// Whether biometric login is currently loading
  final bool isLoading;

  const BiometricLoginWidget({
    super.key,
    required this.isBiometricAvailable,
    required this.onBiometricLogin,
    required this.isLoading,
  });

  @override
  State<BiometricLoginWidget> createState() => _BiometricLoginWidgetState();
}

class _BiometricLoginWidgetState extends State<BiometricLoginWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isBiometricAvailable) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getBiometricType() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Face ID / Touch ID';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Fingerprint';
    }
    return 'Biometric';
  }

  IconData _getBiometricIcon() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Icons.face;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return Icons.fingerprint;
    }
    return Icons.security;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!widget.isBiometricAvailable) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: 3.h),

        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Quick Access',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Biometric Login Button
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: GestureDetector(
                  onTap: widget.isLoading
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          widget.onBiometricLogin();
                        },
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: widget.isLoading
                        ? Center(
                            child: SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        : CustomIconWidget(
                            iconName: _getBiometricIcon().codePoint.toString(),
                            color: theme.colorScheme.primary,
                            size: 8.w,
                          ),
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        // Biometric Login Text
        Text(
          'Use ${_getBiometricType()}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 1.h),

        Text(
          'Tap to authenticate securely',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
