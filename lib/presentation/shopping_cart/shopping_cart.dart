import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/cart_item_card.dart';
import './widgets/cart_summary_card.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/related_products_section.dart';
import './widgets/saved_for_later_section.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  int _currentBottomNavIndex = 2; // Cart tab active
  bool _showPromoCode = false;
  bool _savedForLaterExpanded = false;
  bool _isBulkOrderMode = false;
  final TextEditingController _promoController = TextEditingController();
  String? _promoError;
  double _discount = 0.0;

  // Mock cart data
  final List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "LED Smart Bulb 9W",
      "specifications": "Dimmable, WiFi Enabled, E27 Base",
      "price": 3231.21,
      "quantity": 2,
      "image":
          "https://images.pexels.com/photos/1112598/pexels-photo-1112598.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Lighting",
      "isNew": false,
    },
    {
      "id": 2,
      "name": "Electrical Wire 12 AWG",
      "specifications": "Copper, 100ft Roll, THHN Insulation",
      "price": 11572.35,
      "quantity": 1,
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Wiring",
      "isNew": true,
    },
    {
      "id": 3,
      "name": "Circuit Breaker 20A",
      "specifications": "Single Pole, 120V, UL Listed",
      "price": 2036.48,
      "quantity": 3,
      "image":
          "https://images.pexels.com/photos/162553/keys-workshop-mechanic-tools-162553.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Safety",
      "isNew": false,
    },
  ];

  // Mock saved for later items
  final List<Map<String, dynamic>> _savedForLaterItems = [
    {
      "id": 4,
      "name": "USB Wall Outlet",
      "price": 4266.21,
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Outlets",
    },
    {
      "id": 5,
      "name": "Motion Sensor Switch",
      "price": 5818.50,
      "image":
          "https://images.pexels.com/photos/1112598/pexels-photo-1112598.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Switches",
    },
  ];

  // Mock related products
  final List<Map<String, dynamic>> _relatedProducts = [
    {
      "id": 6,
      "name": "Extension Cord 25ft",
      "price": 3748.41,
      "rating": 4.5,
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isNew": false,
    },
    {
      "id": 7,
      "name": "Voltage Tester",
      "price": 2584.71,
      "rating": 4.8,
      "image":
          "https://images.pexels.com/photos/162553/keys-workshop-mechanic-tools-162553.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isNew": true,
    },
    {
      "id": 8,
      "name": "Wire Nuts Assorted",
      "price": 1616.25,
      "rating": 4.3,
      "image":
          "https://images.pexels.com/photos/1112598/pexels-photo-1112598.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isNew": false,
    },
  ];

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      type: CustomAppBarType.standard,
      title: 'Shopping Cart',
      showBackButton: true,
      showCart: false,
      actions: [
        if (_cartItems.isNotEmpty)
          TextButton(
            onPressed: _showClearAllDialog,
            child: Text(
              'Clear All',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        if (_cartItems.isNotEmpty)
          IconButton(
            onPressed: _toggleBulkOrderMode,
            icon: CustomIconWidget(
              iconName: _isBulkOrderMode ? 'business' : 'business_center',
              color: _isBulkOrderMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            tooltip: _isBulkOrderMode ? 'Exit Bulk Mode' : 'Bulk Order Mode',
          ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return EmptyCartWidget(
      onStartShopping: () {
        Navigator.pushNamed(context, '/product-dashboard');
      },
    );
  }

  Widget _buildCartContent() {
    return RefreshIndicator(
      onRefresh: _refreshCart,
      child: CustomScrollView(
        slivers: [
          if (_isBulkOrderMode) _buildBulkOrderHeader(),
          _buildCartItemsList(),
          _buildSavedForLaterSliver(),
          _buildRelatedProductsSliver(),
          _buildBottomSpacing(),
        ],
      ),
    );
  }

  Widget _buildBulkOrderHeader() {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(4.w),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'business',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bulk Order Mode',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Special discounts available for quantities over 10',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = _cartItems[index];
          return CartItemCard(
            item: item,
            onRemove: () => _removeItem(item),
            onQuantityChanged: (newQuantity) =>
                _updateQuantity(item, newQuantity),
            onMoveToWishlist: () => _moveToWishlist(item),
            onSaveForLater: () => _saveForLater(item),
            onViewDetails: () => _viewProductDetails(item),
          );
        },
        childCount: _cartItems.length,
      ),
    );
  }

  Widget _buildSavedForLaterSliver() {
    return SliverToBoxAdapter(
      child: SavedForLaterSection(
        savedItems: _savedForLaterItems,
        isExpanded: _savedForLaterExpanded,
        onToggleExpanded: () {
          setState(() {
            _savedForLaterExpanded = !_savedForLaterExpanded;
          });
        },
        onMoveToCart: _moveToCart,
        onRemoveFromSaved: _removeFromSaved,
      ),
    );
  }

  Widget _buildRelatedProductsSliver() {
    return SliverToBoxAdapter(
      child: RelatedProductsSection(
        relatedProducts: _relatedProducts,
        onAddToCart: _addRelatedProductToCart,
        onProductTap: _viewRelatedProduct,
      ),
    );
  }

  Widget _buildBottomSpacing() {
    return SliverToBoxAdapter(
      child: SizedBox(height: 25.h), // Space for sticky summary card
    );
  }

  Widget _buildBottomNavigation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_cartItems.isNotEmpty) _buildSummaryCard(),
        CustomBottomBar(
          currentIndex: _currentBottomNavIndex,
          onTap: _onBottomNavTap,
          cartItemCount: _cartItems.length,
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final subtotal = _calculateSubtotal();
    final tax = _calculateTax(subtotal);
    final shipping = _calculateShipping();
    final total = subtotal + tax + shipping - _discount;

    return CartSummaryCard(
      subtotal: subtotal,
      tax: tax,
      shipping: shipping,
      total: total,
      discount: _discount,
      showPromoCode: _showPromoCode,
      onTogglePromoCode: () {
        setState(() {
          _showPromoCode = !_showPromoCode;
        });
      },
      promoController: _promoController,
      onApplyPromo: _applyPromoCode,
      promoError: _promoError,
      onCheckout: _proceedToCheckout,
    );
  }

  // Cart operations
  void _removeItem(Map<String, dynamic> item) {
    setState(() {
      _cartItems.removeWhere((cartItem) => cartItem['id'] == item['id']);
    });
    HapticFeedback.lightImpact();
    _showSnackBar('${item['name']} removed from cart');
  }

  void _updateQuantity(Map<String, dynamic> item, int newQuantity) {
    setState(() {
      final index =
          _cartItems.indexWhere((cartItem) => cartItem['id'] == item['id']);
      if (index != -1) {
        _cartItems[index]['quantity'] = newQuantity;
      }
    });
  }

  void _moveToWishlist(Map<String, dynamic> item) {
    _removeItem(item);
    _showSnackBar('${item['name']} moved to wishlist');
  }

  void _saveForLater(Map<String, dynamic> item) {
    setState(() {
      _savedForLaterItems.add({
        'id': item['id'],
        'name': item['name'],
        'price': item['price'],
        'image': item['image'],
        'category': item['category'],
      });
    });
    _removeItem(item);
    _showSnackBar('${item['name']} saved for later');
  }

  void _viewProductDetails(Map<String, dynamic> item) {
    Navigator.pushNamed(context, '/product-detail', arguments: item);
  }

  void _moveToCart(Map<String, dynamic> item) {
    setState(() {
      _cartItems.add({
        ...item,
        'quantity': 1,
        'specifications': 'Standard specifications',
      });
      _savedForLaterItems
          .removeWhere((savedItem) => savedItem['id'] == item['id']);
    });
    _showSnackBar('${item['name']} moved to cart');
  }

  void _removeFromSaved(Map<String, dynamic> item) {
    setState(() {
      _savedForLaterItems
          .removeWhere((savedItem) => savedItem['id'] == item['id']);
    });
    _showSnackBar('${item['name']} removed from saved items');
  }

  void _addRelatedProductToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add({
        ...product,
        'quantity': 1,
        'specifications': 'Standard specifications',
      });
    });
    HapticFeedback.lightImpact();
    _showSnackBar('${product['name']} added to cart');
  }

  void _viewRelatedProduct(Map<String, dynamic> product) {
    Navigator.pushNamed(context, '/product-detail', arguments: product);
  }

  // Calculations
  double _calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) {
      final price = item['price'] as double? ?? 0.0;
      final quantity = item['quantity'] as int? ?? 1;
      return sum + (price * quantity);
    });
  }

  double _calculateTax(double subtotal) {
    return subtotal * 0.08; // 8% tax rate
  }

  double _calculateShipping() {
    final subtotal = _calculateSubtotal();
    return subtotal > 75.0 ? 0.0 : 9.99; // Free shipping over \$75
  }

  // Promo code handling
  void _applyPromoCode() {
    final promoCode = _promoController.text.trim().toUpperCase();
    setState(() {
      _promoError = null;

      switch (promoCode) {
        case 'SAVE10':
          _discount = _calculateSubtotal() * 0.10;
          _showSnackBar('10% discount applied!');
          break;
        case 'WELCOME20':
          _discount = _calculateSubtotal() * 0.20;
          _showSnackBar('20% welcome discount applied!');
          break;
        case 'BULK15':
          if (_isBulkOrderMode) {
            _discount = _calculateSubtotal() * 0.15;
            _showSnackBar('15% bulk discount applied!');
          } else {
            _promoError = 'This code is only valid for bulk orders';
          }
          break;
        default:
          _promoError = 'Invalid promo code';
      }
    });
  }

  // UI actions
  void _showClearAllDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear Cart',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to remove all items from your cart?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _cartItems.clear();
                  _discount = 0.0;
                  _promoController.clear();
                  _showPromoCode = false;
                });
                _showSnackBar('Cart cleared');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _toggleBulkOrderMode() {
    setState(() {
      _isBulkOrderMode = !_isBulkOrderMode;
    });
    _showSnackBar(_isBulkOrderMode
        ? 'Bulk order mode enabled - Special discounts available!'
        : 'Bulk order mode disabled');
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) return;

    // Navigate to checkout screen (not implemented in this example)
    _showSnackBar('Proceeding to secure checkout...');

    // In a real app, you would navigate to checkout:
    // Navigator.pushNamed(context, '/checkout');
  }

  Future<void> _refreshCart() async {
    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));
    _showSnackBar('Cart updated');
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/product-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/product-search');
        break;
      case 2:
        // Already on cart screen
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
