import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// App logo widget displaying the ElectroShop brand logo and name
class AppLogoWidget extends StatelessWidget {
  /// Size of the logo
  final double? logoSize;

  /// Whether to show the app name below logo
  final bool showAppName;

  /// Custom app name text
  final String? appName;

  const AppLogoWidget({
    super.key,
    this.logoSize,
    this.showAppName = true,
    this.appName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLogoSize = logoSize ?? 15.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Container with electrical theme
        Container(
          width: effectiveLogoSize,
          height: effectiveLogoSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(effectiveLogoSize * 0.2),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background electrical pattern
              CustomIconWidget(
                iconName: 'electrical_services',
                color: Colors.white.withValues(alpha: 0.2),
                size: effectiveLogoSize * 0.8,
              ),
              // Main logo icon
              CustomIconWidget(
                iconName: 'flash_on',
                color: Colors.white,
                size: effectiveLogoSize * 0.5,
              ),
            ],
          ),
        ),

        if (showAppName) ...[
          SizedBox(height: 2.h),

          // App Name
          Text(
            appName ?? 'ElectroShop',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: 0.5.h),

          // App Tagline
          Text(
            'Your Electrical Store',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
