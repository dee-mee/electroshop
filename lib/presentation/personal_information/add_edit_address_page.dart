import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class AddEditAddressPage extends StatefulWidget {
  final Map<String, dynamic>? address;

  const AddEditAddressPage({super.key, this.address});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _phoneController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.address?['title']);
    _nameController = TextEditingController(text: widget.address?['name']);
    _addressController = TextEditingController(text: widget.address?['address']);
    _cityController = TextEditingController(text: widget.address?['city']);
    _stateController = TextEditingController(text: widget.address?['state']);
    _zipCodeController = TextEditingController(text: widget.address?['zipCode']);
    _phoneController = TextEditingController(text: widget.address?['phone']);
    _isDefault = widget.address?['isDefault'] ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final newAddress = {
        "id": widget.address?['id'] ?? DateTime.now().millisecondsSinceEpoch,
        "title": _titleController.text,
        "name": _nameController.text,
        "address": _addressController.text,
        "city": _cityController.text,
        "state": _stateController.text,
        "zipCode": _zipCodeController.text,
        "phone": _phoneController.text,
        "isDefault": _isDefault,
      };
      Navigator.pop(context, newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add New Address' : 'Edit Address'),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _titleController,
                labelText: 'Title (e.g., Home, Work)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                controller: _nameController,
                labelText: 'Full Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                controller: _addressController,
                labelText: 'Address Line 1',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                controller: _cityController,
                labelText: 'City',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                controller: _stateController,
                labelText: 'State/Province',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a state/province';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                controller: _zipCodeController,
                labelText: 'Zip/Postal Code',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a zip/postal code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              CheckboxListTile(
                title: Text('Set as Default Address'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  minimumSize: Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                ),
                child: Text(widget.address == null ? 'Add Address' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      ),
      validator: validator,
    );
  }
}
