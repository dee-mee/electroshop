import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_menu_section_widget.dart';
import './widgets/profile_settings_widget.dart';
import './widgets/profile_stats_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'KSH';

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "Michael Rodriguez",
    "email": "michael.rodriguez@email.com",
    "profileImage":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    "memberSince": "2022-03-15",
    "totalOrders": 47,
    "wishlistItems": 12,
    "reviewsGiven": 23,
    "totalSpent": 2847.50,
    "isVerified": true,
    "isPremium": true,
  };

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout from your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
        context, '/login-screen', (route) => false);
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'This action cannot be undone. Your account and all data will be permanently deleted.'),
              SizedBox(height: 16),
              Text(
                'This includes:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text('• Order history and receipts'),
              Text('• Wishlist and saved items'),
              Text('• Reviews and ratings'),
              Text('• Payment methods'),
              Text('• Personal information'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showDataExportDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Your Data'),
          content: Text(
              'Would you like to export your data before deleting your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteAccount();
              },
              child: Text('Skip Export'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _exportDataAndDelete();
              },
              child: Text('Export & Delete'),
            ),
          ],
        );
      },
    );
  }

  void _exportDataAndDelete() {
    // Simulate data export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data exported successfully. Account will be deleted.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
    _deleteAccount();
  }

  void _deleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account deleted successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
        context, '/login-screen', (route) => false);
  }

  List<ProfileMenuItem> _getAccountMenuItems() {
    return [
      ProfileMenuItem(
        icon: 'person',
        title: 'Personal Information',
        subtitle: 'Name, email, phone number',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.personalInformation);
        },
      ),
      ProfileMenuItem(
        icon: 'location_on',
        title: 'Addresses',
        subtitle: 'Manage shipping addresses',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.manageAddresses);
        },
      ),
      ProfileMenuItem(
        icon: 'payment',
        title: 'Payment Methods',
        subtitle: 'Cards and payment options',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Methods screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'lock',
        title: 'Password & Security',
        subtitle: 'Change password and security settings',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Security settings screen coming soon')),
          );
        },
      ),
    ];
  }

  List<ProfileMenuItem> _getOrderMenuItems() {
    return [
      ProfileMenuItem(
        icon: 'history',
        title: 'Order History',
        subtitle: 'View past orders and receipts',
        badge: (_userData["totalOrders"] as int) > 0
            ? (_userData["totalOrders"] as int).toString()
            : null,
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.orderHistory);
        },
      ),
      ProfileMenuItem(
        icon: 'assignment_return',
        title: 'Returns & Refunds',
        subtitle: 'Manage returns and refunds',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Returns screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'favorite',
        title: 'Wishlist',
        subtitle: 'Your saved electrical products',
        badge: (_userData["wishlistItems"] as int) > 0
            ? (_userData["wishlistItems"] as int).toString()
            : null,
        iconColor: Colors.red,
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.wishlist);
        },
      ),
    ];
  }

  List<ProfileMenuItem> _getBusinessMenuItems() {
    return [
      ProfileMenuItem(
        icon: 'receipt_long',
        title: 'Tax Information',
        subtitle: 'Business tax details',
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Verified',
            style: TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tax Information screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'local_offer',
        title: 'Bulk Pricing',
        subtitle: 'Contractor discounts and pricing',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bulk Pricing screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'description',
        title: 'Purchase Orders',
        subtitle: 'Manage business purchase orders',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Purchase Orders screen coming soon')),
          );
        },
      ),
    ];
  }

  List<ProfileMenuItem> _getSupportMenuItems() {
    return [
      ProfileMenuItem(
        icon: 'help_center',
        title: 'Help Center',
        subtitle: 'Electrical product guides and FAQs',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Help Center screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'contact_support',
        title: 'Contact Us',
        subtitle: 'Get in touch with our support team',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact Us screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'chat',
        title: 'Live Chat',
        subtitle: 'Chat with electrical experts',
        trailing: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Live Chat screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'quiz',
        title: 'FAQ',
        subtitle: 'Frequently asked questions',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('FAQ screen coming soon')),
          );
        },
      ),
    ];
  }

  List<ProfileMenuItem> _getSecurityMenuItems() {
    return [
      ProfileMenuItem(
        icon: 'login',
        title: 'Login Activity',
        subtitle: 'Recent login sessions',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Activity screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'security',
        title: 'Two-Factor Authentication',
        subtitle: 'Add extra security to your account',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Two-Factor Authentication screen coming soon')),
          );
        },
      ),
      ProfileMenuItem(
        icon: 'delete_forever',
        title: 'Delete Account',
        subtitle: 'Permanently delete your account',
        iconColor: Colors.red,
        onTap: _showDeleteAccountDialog,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.productDashboard,
            (route) => false,
          ),
          icon: CustomIconWidget(
            iconName: 'home',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(
              userName: _userData["name"] as String,
              userEmail: _userData["email"] as String,
              profileImageUrl: _userData["profileImage"] as String?,
              onEditProfile: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit Profile screen coming soon')),
                );
              },
            ),
            SizedBox(height: 8),
            ProfileStatsWidget(
              totalOrders: _userData["totalOrders"] as int,
              wishlistItems: _userData["wishlistItems"] as int,
              reviewsGiven: _userData["reviewsGiven"] as int,
              totalSpent: _userData["totalSpent"] as double,
            ),
            ProfileMenuSectionWidget(
              title: 'Account',
              items: _getAccountMenuItems(),
            ),
            ProfileMenuSectionWidget(
              title: 'Orders & Wishlist',
              items: _getOrderMenuItems(),
            ),
            ProfileSettingsWidget(
              isDarkMode: _isDarkMode,
              notificationsEnabled: _notificationsEnabled,
              biometricEnabled: _biometricEnabled,
              selectedLanguage: _selectedLanguage,
              selectedCurrency: _selectedCurrency,
              onDarkModeChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Theme changed to ${value ? 'Dark' : 'Light'} mode'),
                  ),
                );
              },
              onNotificationsChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Notifications ${value ? 'enabled' : 'disabled'}'),
                  ),
                );
              },
              onBiometricChanged: (value) {
                setState(() {
                  _biometricEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Biometric login ${value ? 'enabled' : 'disabled'}'),
                  ),
                );
              },
              onLanguageChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language changed to $value'),
                  ),
                );
              },
              onCurrencyChanged: (value) {
                setState(() {
                  _selectedCurrency = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Currency changed to $value'),
                  ),
                );
              },
            ),
            ProfileMenuSectionWidget(
              title: 'Business (Contractors)',
              items: _getBusinessMenuItems(),
            ),
            ProfileMenuSectionWidget(
              title: 'Support',
              items: _getSupportMenuItems(),
            ),
            ProfileMenuSectionWidget(
              title: 'Security',
              items: _getSecurityMenuItems(),
            ),
            Container(
              margin: EdgeInsets.all(16),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.productDashboard,
                        (route) => false,
                      ),
                      icon: CustomIconWidget(
                        iconName: 'home',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Back to Home'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showLogoutDialog,
                      icon: CustomIconWidget(
                        iconName: 'logout',
                        color: theme.colorScheme.onError,
                        size: 20,
                      ),
                      label: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}