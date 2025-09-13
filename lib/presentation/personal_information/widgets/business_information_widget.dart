import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BusinessInformationWidget extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController licenseNumberController;
  final TextEditingController taxIdController;
  final bool isVerifiedContractor;

  const BusinessInformationWidget({
    super.key,
    required this.companyNameController,
    required this.licenseNumberController,
    required this.taxIdController,
    required this.isVerifiedContractor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Business Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            if (isVerifiedContractor)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'verified',
                      size: 12,
                      color: Colors.green,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
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
              TextFormField(
                controller: companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  helperText: 'Optional: For contractor accounts',
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: licenseNumberController,
                decoration: InputDecoration(
                  labelText: 'Electrical License Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  helperText: 'Required for contractor verification',
                  suffixIcon: isVerifiedContractor
                      ? Padding(
                          padding: EdgeInsets.all(12),
                          child: CustomIconWidget(
                            iconName: 'verified',
                            size: 20,
                            color: Colors.green,
                          ),
                        )
                      : null,
                ),
                validator: (value) {
                  if (companyNameController.text.isNotEmpty &&
                      (value == null || value.isEmpty)) {
                    return 'License number is required for business accounts';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-]')),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: taxIdController,
                decoration: InputDecoration(
                  labelText: 'Tax ID / EIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  helperText: 'Format: 12-3456789',
                ),
                validator: (value) {
                  if (companyNameController.text.isNotEmpty &&
                      (value == null || value.isEmpty)) {
                    return 'Tax ID is required for business accounts';
                  }
                  if (value != null &&
                      value.isNotEmpty &&
                      !RegExp(r'^\d{2}-\d{7}$').hasMatch(value)) {
                    return 'Please enter a valid Tax ID (XX-XXXXXXX)';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                  LengthLimitingTextInputFormatter(10),
                  _TaxIdInputFormatter(),
                ],
              ),
            ],
          ),
        ),
        if (!isVerifiedContractor && companyNameController.text.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    size: 20,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Business information is under review. Verification typically takes 2-3 business days.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TaxIdInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length <= 2) {
      return newValue;
    }

    if (text.length <= 10 && !text.contains('-')) {
      final formatted = text.substring(0, 2) + '-' + text.substring(2);
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return newValue;
  }
}
