import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './quantity_selector.dart';

class StickyBottomBar extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const StickyBottomBar({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  State<StickyBottomBar> createState() => _StickyBottomBarState();
}

class _StickyBottomBarState extends State<StickyBottomBar> {
  int _selectedQuantity = 1;
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inStock = widget.product['inStock'] as bool? ?? true;
    final stockCount = widget.product['stockCount'] as int? ?? 99;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quantity selector and price
              Row(
                children: [
                  Text(
                    'Quantity:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  QuantitySelector(
                    initialQuantity: _selectedQuantity,
                    maxQuantity: stockCount,
                    onQuantityChanged: (quantity) {
                      setState(() {
                        _selectedQuantity = quantity;
                      });
                    },
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _calculateTotalPrice(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Action buttons
              Row(
                children: [
                  // Add to Cart button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed:
                          inStock && !_isAddingToCart ? _handleAddToCart : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isAddingToCart
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'shopping_cart',
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  inStock ? 'Add to Cart' : 'Out of Stock',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Buy Now button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: inStock ? widget.onBuyNow : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        side: BorderSide(
                          color: inStock
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: inStock
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Stock warning
              if (inStock && stockCount <= 5)
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.getWarningColor(
                            theme.brightness == Brightness.light)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        size: 16,
                        color: AppTheme.getWarningColor(
                            theme.brightness == Brightness.light),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Only $stockCount left in stock!',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light),
                          fontWeight: FontWeight.w500,
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
  }

  String _calculateTotalPrice() {
    final priceString = widget.product['price'] as String? ?? 'KSH 0.00';
    final priceValue =
        double.tryParse(priceString.replaceAll('KSH ', '').replaceAll(',', '')) ??
            0.0;
    final totalPrice = priceValue * _selectedQuantity;
    return 'KSH${totalPrice.toStringAsFixed(2)}';
  }

  void _handleAddToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isAddingToCart = false;
    });

    // Show confirmation bottom sheet
    _showAddToCartConfirmation();

    widget.onAddToCart();
  }

  void _showAddToCartConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddToCartConfirmationSheet(
        product: widget.product,
        quantity: _selectedQuantity,
        onContinueShopping: () => Navigator.pop(context),
        onGoToCart: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/shopping-cart');
        },
      ),
    );
  }
}

class _AddToCartConfirmationSheet extends StatelessWidget {
  final Map<String, dynamic> product;
  final int quantity;
  final VoidCallback onContinueShopping;
  final VoidCallback onGoToCart;

  const _AddToCartConfirmationSheet({
    required this.product,
    required this.quantity,
    required this.onContinueShopping,
    required this.onGoToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  size: 32,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                'Added to Cart!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light),
                ),
              ),

              SizedBox(height: 2.h),

              // Product summary
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CustomImageWidget(
                          imageUrl: (product['images'] as List<dynamic>?)?.first
                                  as String? ??
                              '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] as String? ?? 'Product',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Quantity: $quantity',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      product['price'] as String? ?? 'KSH 0.00',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onContinueShopping,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                      ),
                      child: const Text('Continue Shopping'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onGoToCart,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                      ),
                      child: const Text('Go to Cart'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
