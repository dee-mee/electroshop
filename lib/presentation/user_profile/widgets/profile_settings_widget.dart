import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProfileSettingsWidget extends StatefulWidget {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final String selectedLanguage;
  final String selectedCurrency;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onBiometricChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onCurrencyChanged;

  const ProfileSettingsWidget({
    super.key,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.biometricEnabled,
    required this.selectedLanguage,
    required this.selectedCurrency,
    required this.onDarkModeChanged,
    required this.onNotificationsChanged,
    required this.onBiometricChanged,
    required this.onLanguageChanged,
    required this.onCurrencyChanged,
  });

  @override
  State<ProfileSettingsWidget> createState() => _ProfileSettingsWidgetState();
}

class _ProfileSettingsWidgetState extends State<ProfileSettingsWidget> {
  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  final List<String> _currencies = ['KSH', 'EUR', 'GBP', 'CAD', 'KES'];

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Language',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              ..._languages
                  .map((language) => ListTile(
                        title: Text(language),
                        trailing: widget.selectedLanguage == language
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: theme.colorScheme.primary,
                                size: 20,
                              )
                            : null,
                        onTap: () {
                          widget.onLanguageChanged(language);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencySelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Currency',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              ..._currencies
                  .map((currency) => ListTile(
                        title: Text(currency),
                        trailing: widget.selectedCurrency == currency
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: theme.colorScheme.primary,
                                size: 20,
                              )
                            : null,
                        onTap: () {
                          widget.onCurrencyChanged(currency);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'App Settings',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          _buildSwitchTile(
            context,
            icon: 'dark_mode',
            title: 'Dark Mode',
            subtitle: 'Switch between light and dark theme',
            value: widget.isDarkMode,
            onChanged: widget.onDarkModeChanged,
          ),
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          _buildSwitchTile(
            context,
            icon: 'notifications',
            title: 'Push Notifications',
            subtitle: 'Order updates and promotions',
            value: widget.notificationsEnabled,
            onChanged: widget.onNotificationsChanged,
          ),
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          _buildSwitchTile(
            context,
            icon: 'fingerprint',
            title: 'Biometric Login',
            subtitle: 'Use fingerprint or face ID',
            value: widget.biometricEnabled,
            onChanged: widget.onBiometricChanged,
          ),
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          _buildSelectTile(
            context,
            icon: 'language',
            title: 'Language',
            subtitle: widget.selectedLanguage,
            onTap: _showLanguageSelector,
          ),
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          _buildSelectTile(
            context,
            icon: 'attach_money',
            title: 'Currency',
            subtitle: widget.selectedCurrency,
            onTap: _showCurrencySelector,
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
