import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_information_widget.dart';
import './widgets/personal_details_form_widget.dart';
import './widgets/profile_photo_section_widget.dart';
import './widgets/security_settings_widget.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();

  // State variables
  String? _profileImagePath;
  bool _hasChanges = false;
  bool _isVerifiedContractor = false;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;
  bool _safetyAlerts = true;
  bool _twoFactorEnabled = false;
  String _twoFactorMethod = 'SMS';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setupFormListeners();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _licenseNumberController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Load user data (mock data)
    _firstNameController.text = 'Michael';
    _lastNameController.text = 'Rodriguez';
    _emailController.text = 'michael.rodriguez@email.com';
    _phoneController.text = '+1 (555) 123-4567';
    _companyNameController.text = 'Rodriguez Electric LLC';
    _licenseNumberController.text = 'EC-2024-001234';
    _taxIdController.text = '12-3456789';
    _profileImagePath =
        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png';
    _isVerifiedContractor = true;
    _twoFactorEnabled = false;
  }

  void _setupFormListeners() {
    _firstNameController.addListener(_onFormChanged);
    _lastNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _companyNameController.addListener(_onFormChanged);
    _licenseNumberController.addListener(_onFormChanged);
    _taxIdController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
          _hasChanges = true;
        });
      }
    } catch (e) {
      _showErrorMessage('Failed to pick image');
    }
  }

  void _showImageSourceDialog() {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 16),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Update Profile Photo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'photo_camera',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'photo_library',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    Navigator.pop(context); // Close loading dialog

    setState(() {
      _hasChanges = false;
    });

    _showSuccessMessage('Profile updated successfully');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _setupTwoFactor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
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
                ),
                SizedBox(height: 20),
                Text(
                  'Two-Factor Authentication',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 16),
                Text(
                  'Secure your account with an additional verification step.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                SizedBox(height: 24),
                RadioListTile<String>(
                  title: Text('SMS Verification'),
                  subtitle: Text('Receive codes via text message'),
                  value: 'SMS',
                  groupValue: _twoFactorMethod,
                  onChanged: (value) {
                    setState(() {
                      _twoFactorMethod = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Authenticator App'),
                  subtitle: Text('Use Google Authenticator or similar'),
                  value: 'APP',
                  groupValue: _twoFactorMethod,
                  onChanged: (value) {
                    setState(() {
                      _twoFactorMethod = value!;
                    });
                  },
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _twoFactorEnabled = true;
                            _hasChanges = true;
                          });
                          Navigator.pop(context);
                          _showSuccessMessage(
                              'Two-factor authentication enabled');
                        },
                        child: Text('Enable'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Personal Information'),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Section
              ProfilePhotoSectionWidget(
                profileImagePath: _profileImagePath,
                isVerifiedContractor: _isVerifiedContractor,
                onImageTap: _showImageSourceDialog,
              ),

              SizedBox(height: 24),

              // Personal Details Form
              PersonalDetailsFormWidget(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                emailController: _emailController,
                phoneController: _phoneController,
              ),

              SizedBox(height: 24),

              // Business Information
              BusinessInformationWidget(
                companyNameController: _companyNameController,
                licenseNumberController: _licenseNumberController,
                taxIdController: _taxIdController,
                isVerifiedContractor: _isVerifiedContractor,
              ),

              SizedBox(height: 24),

              // Communication Preferences
              Text(
                'Communication Preferences',
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
                    SwitchListTile(
                      title: Text('Email Notifications'),
                      subtitle: Text('Order updates and promotions'),
                      value: _emailNotifications,
                      onChanged: (value) {
                        setState(() {
                          _emailNotifications = value;
                          _hasChanges = true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: Text('SMS Notifications'),
                      subtitle: Text('Delivery alerts and urgent updates'),
                      value: _smsNotifications,
                      onChanged: (value) {
                        setState(() {
                          _smsNotifications = value;
                          _hasChanges = true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: Text('Push Notifications'),
                      subtitle: Text('App notifications'),
                      value: _pushNotifications,
                      onChanged: (value) {
                        setState(() {
                          _pushNotifications = value;
                          _hasChanges = true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: Text('Safety Alerts'),
                      subtitle: Text('Electrical safety and product recalls'),
                      value: _safetyAlerts,
                      onChanged: (value) {
                        setState(() {
                          _safetyAlerts = value;
                          _hasChanges = true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Security Settings
              SecuritySettingsWidget(
                twoFactorEnabled: _twoFactorEnabled,
                twoFactorMethod: _twoFactorMethod,
                onSetupTwoFactor: _setupTwoFactor,
                onDisableTwoFactor: () {
                  setState(() {
                    _twoFactorEnabled = false;
                    _hasChanges = true;
                  });
                  _showSuccessMessage('Two-factor authentication disabled');
                },
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _hasChanges
          ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _hasChanges = false;
                          });
                          _loadUserData(); // Reset form
                        },
                        child: Text('Discard Changes'),
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
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        child: Text('Save Changes'),
                        style: ElevatedButton.styleFrom(
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
            )
          : null,
    );
  }
}
