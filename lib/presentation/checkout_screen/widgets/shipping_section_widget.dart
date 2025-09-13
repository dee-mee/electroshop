import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ShippingSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> savedAddresses;
  final Map<String, dynamic>? selectedAddress;
  final String selectedDeliveryOption;
  final Function(Map<String, dynamic>) onAddressSelected;
  final Function(String) onDeliveryOptionChanged;
  final VoidCallback onAddNewAddress;

  const ShippingSectionWidget({
    super.key,
    required this.savedAddresses,
    this.selectedAddress,
    required this.selectedDeliveryOption,
    required this.onAddressSelected,
    required this.onDeliveryOptionChanged,
    required this.onAddNewAddress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Address',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          // Saved Addresses
          ...savedAddresses.map((address) {
            final isSelected = selectedAddress?['id'] == address['id'];

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onAddressSelected(address),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: address['id'],
                        groupValue: selectedAddress?['id'],
                        onChanged: (value) => onAddressSelected(address),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  address['title'],
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (address['isDefault']) ...[
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Default',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              address['name'],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${address['address']}, ${address['city']}, ${address['state']} ${address['zipCode']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              address['phone'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          // Add New Address Button
          InkWell(
            onTap: onAddNewAddress,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add New Address',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 32),

          // Delivery Options
          Text(
            'Delivery Options',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          _buildDeliveryOption(
            context,
            'standard',
            'Standard Delivery',
            '5-7 business days',
            'KSH 774.51',
            'local_shipping',
          ),

          _buildDeliveryOption(
            context,
            'expedited',
            'Expedited Delivery',
            '2-3 business days',
            'KSH 2067.51',
            'speed',
          ),

          _buildDeliveryOption(
            context,
            'contractor',
            'Contractor Bulk Delivery',
            'Schedule installation delivery',
            'KSH 3359.51',
            'construction',
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption(
    BuildContext context,
    String value,
    String title,
    String description,
    String price,
    String icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = selectedDeliveryOption == value;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onDeliveryOptionChanged(value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: selectedDeliveryOption,
                onChanged: (newValue) => onDeliveryOptionChanged(newValue!),
              ),
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: 12),
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
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
