import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class ManageAddressesPage extends StatefulWidget {
  const ManageAddressesPage({super.key});

  @override
  State<ManageAddressesPage> createState() => _ManageAddressesPageState();
}

class _ManageAddressesPageState extends State<ManageAddressesPage> {
  List<Map<String, dynamic>> _addresses = [
    {
      "id": 1,
      "title": "Home",
      "name": "Michael Rodriguez",
      "address": "1234 Oak Street",
      "city": "Springfield",
      "state": "IL",
      "zipCode": "62701",
      "phone": "+1 (555) 123-4567",
      "isDefault": true,
    },
    {
      "id": 2,
      "title": "Work Site",
      "name": "Rodriguez Construction",
      "address": "5678 Industrial Blvd",
      "city": "Springfield",
      "state": "IL",
      "zipCode": "62702",
      "phone": "+1 (555) 987-6543",
      "isDefault": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Manage Addresses'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return _buildAddressCard(theme, address);
              },
            ),
          ),
          _buildAddNewAddressButton(theme),
        ],
      ),
    );
  }

  Widget _buildAddressCard(ThemeData theme, Map<String, dynamic> address) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                address['title'],
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (address['isDefault'])
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    'Default',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            address['name'],
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${address['address']}, ${address['city']}, ${address['state']} ${address['zipCode']}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            address['phone'],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _editAddress(address),
                child: Text('Edit'),
              ),
              SizedBox(width: 2.w),
              TextButton(
                onPressed: () => _deleteAddress(address),
                child: Text(
                  'Delete',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewAddressButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _addNewAddress,
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 20,
        ),
        label: Text('Add New Address'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
        ),
      ),
    );
  }

  void _addNewAddress() async {
    final newAddress = await Navigator.pushNamed(
      context,
      AppRoutes.addEditAddress,
    );

    if (newAddress != null && newAddress is Map<String, dynamic>) {
      setState(() {
        // If a new address is set as default, unset previous default
        if (newAddress['isDefault']) {
          _addresses = _addresses.map((addr) {
            return {...addr, 'isDefault': false};
          }).toList();
        }
        _addresses.add(newAddress);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address added successfully!')),
      );
    }
  }

  void _editAddress(Map<String, dynamic> address) async {
    final updatedAddress = await Navigator.pushNamed(
      context,
      AppRoutes.addEditAddress,
      arguments: address,
    );

    if (updatedAddress != null && updatedAddress is Map<String, dynamic>) {
      setState(() {
        final index = _addresses.indexWhere((addr) => addr['id'] == updatedAddress['id']);
        if (index != -1) {
          // If updated address is set as default, unset previous default
          if (updatedAddress['isDefault']) {
            _addresses = _addresses.map((addr) {
              return {...addr, 'isDefault': false};
            }).toList();
          }
          _addresses[index] = updatedAddress;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address updated successfully!')),
      );
    }
  }

  void _deleteAddress(Map<String, dynamic> address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Delete Address'),
          content: Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final wasDefault = address['isDefault'];
                  _addresses.removeWhere((addr) => addr['id'] == address['id']);

                  if (wasDefault && _addresses.isNotEmpty) {
                    _addresses.first['isDefault'] = true;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Address deleted successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
