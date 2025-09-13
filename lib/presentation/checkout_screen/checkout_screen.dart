import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/checkout_progress_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/payment_section_widget.dart';
import './widgets/shipping_section_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  bool _isProcessingOrder = false;
  bool _termsAccepted = false;
  String? _promoCode;
  double _discount = 0.0;

  // Mock cart items
  final List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "LED Smart Bulb 60W",
      "specifications": "Dimmable, WiFi Enabled",
      "price": 3231.21,
      "quantity": 2,
      "image":
          "https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
    {
      "id": 2,
      "name": "GFCI Outlet 20A",
      "specifications": "Tamper Resistant, White",
      "price": 2455.41,
      "quantity": 1,
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
  ];

  // Mock addresses
  final List<Map<String, dynamic>> _savedAddresses = [
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

  // Mock payment methods
  final List<Map<String, dynamic>> _savedPaymentMethods = [
    {
      "id": 1,
      "type": "card",
      "brand": "Visa",
      "last4": "4242",
      "expiryMonth": 12,
      "expiryYear": 2025,
      "isDefault": true,
    },
    {
      "id": 2,
      "type": "card",
      "brand": "Mastercard",
      "last4": "8888",
      "expiryMonth": 8,
      "expiryYear": 2026,
      "isDefault": false,
    },
  ];

  Map<String, dynamic>? _selectedAddress;
  Map<String, dynamic>? _selectedPaymentMethod;
  String _selectedDeliveryOption = 'standard';

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
  }

  void _initializeDefaults() {
    _selectedAddress = _savedAddresses.firstWhere(
      (address) => address['isDefault'] == true,
      orElse: () => _savedAddresses.first,
    );

    _selectedPaymentMethod = _savedPaymentMethods.firstWhere(
      (payment) => payment['isDefault'] == true,
      orElse: () => _savedPaymentMethods.first,
    );
  }

  double get _subtotal {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double get _deliveryFee {
    switch (_selectedDeliveryOption) {
      case 'expedited':
        return 2067.51;
      case 'contractor':
        return 3359.51;
      default:
        return 774.51;
    }
  }

  double get _tax {
    return (_subtotal - _discount) * 0.0875; // 8.75% tax
  }

  double get _total {
    return _subtotal + _deliveryFee + _tax - _discount;
  }

  void _applyPromoCode() {
    if (_promoCode?.toUpperCase() == 'ELECTRICAL10') {
      setState(() {
        _discount = _subtotal * 0.1; // 10% discount
      });
      _showSnackBar('Promo code applied! 10% discount', Colors.green);
    } else if (_promoCode?.toUpperCase() == 'CONTRACTOR15') {
      setState(() {
        _discount = _subtotal * 0.15; // 15% discount
      });
      _showSnackBar('Contractor discount applied! 15% off', Colors.green);
    } else {
      setState(() {
        _discount = 0.0;
      });
      _showSnackBar('Invalid promo code', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _placeOrder();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _placeOrder() async {
    if (!_termsAccepted) {
      _showSnackBar('Please accept the terms and conditions', Colors.red);
      return;
    }

    setState(() {
      _isProcessingOrder = true;
    });

    try {
      // Simulate order processing
      await Future.delayed(Duration(seconds: 3));

      // Navigate to order confirmation
      _showOrderConfirmationDialog();
    } catch (error) {
      _showSnackBar('Order processing failed. Please try again.', Colors.red);
    } finally {
      setState(() {
        _isProcessingOrder = false;
      });
    }
  }

  void _showOrderConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.green,
              size: 24,
            ),
            SizedBox(width: 8),
            Text('Order Placed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your order has been successfully placed.'),
            SizedBox(height: 16),
            Text(
              'Order #ELS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Total: KSH${_total.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text('Estimated delivery: 3-5 business days'),
            SizedBox(height: 16),
            Text(
              'A confirmation email has been sent to your registered email address.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.productDashboard,
                (route) => false,
              );
            },
            child: Text('Continue Shopping'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to order tracking
              _showSnackBar('Order tracking feature coming soon', Colors.blue);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.productDashboard,
                (route) => false,
              );
            },
            child: Text('Track Order'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Checkout'),
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
          CheckoutProgressWidget(
            currentStep: _currentStep,
            steps: ['Shipping', 'Payment', 'Review'],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                // Step 1: Shipping
                ShippingSectionWidget(
                  savedAddresses: _savedAddresses,
                  selectedAddress: _selectedAddress,
                  selectedDeliveryOption: _selectedDeliveryOption,
                  onAddressSelected: (address) {
                    setState(() {
                      _selectedAddress = address;
                    });
                  },
                  onDeliveryOptionChanged: (option) {
                    setState(() {
                      _selectedDeliveryOption = option;
                    });
                  },
                  onAddNewAddress: () {
                    _showSnackBar(
                        'Add new address feature coming soon', Colors.blue);
                  },
                ),

                // Step 2: Payment
                PaymentSectionWidget(
                  savedPaymentMethods: _savedPaymentMethods,
                  selectedPaymentMethod: _selectedPaymentMethod,
                  onPaymentMethodSelected: (method) {
                    setState(() {
                      _selectedPaymentMethod = method;
                    });
                  },
                  onAddNewPaymentMethod: () {
                    _showSnackBar(
                        'Add payment method feature coming soon', Colors.blue);
                  },
                ),

                // Step 3: Review
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review Your Order',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),

                      OrderSummaryWidget(
                        cartItems: _cartItems,
                        subtotal: _subtotal,
                        deliveryFee: _deliveryFee,
                        tax: _tax,
                        discount: _discount,
                        total: _total,
                        selectedAddress: _selectedAddress!,
                        selectedPaymentMethod: _selectedPaymentMethod!,
                        selectedDeliveryOption: _selectedDeliveryOption,
                        promoCode: _promoCode,
                        onPromoCodeChanged: (code) {
                          setState(() {
                            _promoCode = code;
                          });
                        },
                        onApplyPromoCode: _applyPromoCode,
                      ),

                      SizedBox(height: 20),

                      // Terms and Conditions
                      CheckboxListTile(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        title: Text('I accept the terms and conditions'),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _isProcessingOrder ? null : _previousStep,
                  child: Text('Back'),
                ),
              ),
            if (_currentStep > 0) SizedBox(width: 16),
            Expanded(
              flex: _currentStep > 0 ? 1 : 2,
              child: ElevatedButton(
                onPressed: _isProcessingOrder ? null : _nextStep,
                child: _isProcessingOrder
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(_currentStep < 2 ? 'Continue' : 'Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
