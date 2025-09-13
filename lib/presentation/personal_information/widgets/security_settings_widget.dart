import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SecuritySettingsWidget extends StatelessWidget {
  final bool twoFactorEnabled;
  final String twoFactorMethod;
  final VoidCallback onSetupTwoFactor;
  final VoidCallback onDisableTwoFactor;

  const SecuritySettingsWidget({
    super.key,
    required this.twoFactorEnabled,
    required this.twoFactorMethod,
    required this.onSetupTwoFactor,
    required this.onDisableTwoFactor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Settings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'security',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Two-Factor Authentication',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  twoFactorEnabled
                      ? 'Enabled via ${twoFactorMethod == 'SMS' ? 'SMS' : 'Authenticator App'}'
                      : 'Add extra security to your account',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: twoFactorEnabled
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'verified',
                              size: 16,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Active',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'chevron_right',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                onTap: twoFactorEnabled ? null : onSetupTwoFactor,
                contentPadding: EdgeInsets.zero,
              ),
              if (twoFactorEnabled) ...[
                Divider(
                  height: 16,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'edit',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  title: Text(
                    'Manage Two-Factor Authentication',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text('Change method or disable'),
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showTwoFactorManagement(context),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
              Divider(
                height: 16,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'lock',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Change Password',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text('Update your account password'),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showChangePassword(context),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'login',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Login Activity',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text('View recent login sessions'),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showLoginActivity(context),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTwoFactorManagement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Manage Two-Factor Authentication',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'edit',
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  title: Text('Change Method'),
                  subtitle: Text('Switch between SMS and authenticator app'),
                  onTap: () {
                    Navigator.pop(context);
                    onSetupTwoFactor();
                  },
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'close',
                    color: Theme.of(context).colorScheme.error,
                    size: 24,
                  ),
                  title: Text('Disable Two-Factor Authentication'),
                  subtitle: Text('Remove extra security from your account'),
                  onTap: () {
                    Navigator.pop(context);
                    _showDisableConfirmation(context);
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDisableConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disable Two-Factor Authentication'),
        content: Text(
          'Are you sure you want to disable two-factor authentication? This will make your account less secure.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDisableTwoFactor();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Disable'),
          ),
        ],
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Change Password screen coming soon')),
    );
  }

  void _showLoginActivity(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login Activity screen coming soon')),
    );
  }
}
