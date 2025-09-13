import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Login form widget containing email and password input fields with validation
class LoginFormWidget extends StatefulWidget {
  /// Callback when form is submitted
  final VoidCallback onSubmit;

  /// Whether form is currently loading
  final bool isLoading;

  /// Email controller for external access
  final TextEditingController emailController;

  /// Password controller for external access
  final TextEditingController passwordController;

  const LoginFormWidget({
    super.key,
    required this.onSubmit,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateForm);
    widget.passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_validateForm);
    widget.passwordController.removeListener(_validateForm);
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isEmailValid = _validateEmail(widget.emailController.text);
      _isPasswordValid = _validatePassword(widget.passwordController.text);
    });
  }

  bool _validateEmail(String email) {
    return email.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  String? _getEmailError(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _getPasswordError(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: _isEmailValid
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20.sp,
                ),
              ),
              suffixIcon: widget.emailController.text.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.all(12.w),
                      child: CustomIconWidget(
                        iconName: _isEmailValid ? 'check_circle' : 'error',
                        color: _isEmailValid
                            ? AppTheme.getSuccessColor(
                                theme.brightness == Brightness.light)
                            : theme.colorScheme.error,
                        size: 20.sp,
                      ),
                    )
                  : null,
              errorStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            validator: (value) => _getEmailError(value ?? ''),
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),

          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: widget.passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: _isPasswordValid
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20.sp,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: widget.isLoading
                    ? null
                    : () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: CustomIconWidget(
                    iconName:
                        _isPasswordVisible ? 'visibility' : 'visibility_off',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20.sp,
                  ),
                ),
              ),
              errorStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            validator: (value) => _getPasswordError(value ?? ''),
            onFieldSubmitted: (_) {
              if (_isFormValid()) {
                widget.onSubmit();
              }
            },
          ),

          SizedBox(height: 2.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      // Navigate to forgot password screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Forgot password feature coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
              child: Text(
                'Forgot Password?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Login Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: (_isFormValid() && !widget.isLoading)
                  ? widget.onSubmit
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                disabledBackgroundColor:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.12),
                disabledForegroundColor:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: widget.isLoading ? 0 : 2,
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 20.sp,
                      width: 20.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Login',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isFormValid() {
    return _isEmailValid && _isPasswordValid;
  }
}
