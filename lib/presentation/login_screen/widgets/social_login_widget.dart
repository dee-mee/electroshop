import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Social login widget providing Google, Apple, and Facebook authentication options
class SocialLoginWidget extends StatelessWidget {
  /// Whether social login is currently loading
  final bool isLoading;

  /// Callback when Google login is tapped
  final VoidCallback onGoogleLogin;

  /// Callback when Apple login is tapped
  final VoidCallback onAppleLogin;

  /// Callback when Facebook login is tapped
  final VoidCallback onFacebookLogin;

  const SocialLoginWidget({
    super.key,
    required this.isLoading,
    required this.onGoogleLogin,
    required this.onAppleLogin,
    required this.onFacebookLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Divider with "OR" text
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
                'OR',
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

        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Google Login
            _SocialLoginButton(
              onTap: isLoading ? null : onGoogleLogin,
              icon: 'g_translate',
              label: 'Google',
              backgroundColor: Colors.white,
              borderColor: theme.colorScheme.outline.withValues(alpha: 0.3),
              textColor: theme.colorScheme.onSurface,
              theme: theme,
            ),

            // Apple Login (iOS only)
            if (defaultTargetPlatform == TargetPlatform.iOS || kIsWeb)
              _SocialLoginButton(
                onTap: isLoading ? null : onAppleLogin,
                icon: 'apple',
                label: 'Apple',
                backgroundColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.white,
                theme: theme,
              ),

            // Facebook Login
            _SocialLoginButton(
              onTap: isLoading ? null : onFacebookLogin,
              icon: 'facebook',
              label: 'Facebook',
              backgroundColor: Color(0xFF1877F2),
              borderColor: Color(0xFF1877F2),
              textColor: Colors.white,
              theme: theme,
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Social Login Description
        Text(
          'Continue with your preferred social account',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Individual social login button widget
class _SocialLoginButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String icon;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final ThemeData theme;

  const _SocialLoginButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: textColor,
                  size: 20.sp,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
