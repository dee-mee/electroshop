import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CartSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final VoidCallback onCheckout;
  final bool showPromoCode;
  final VoidCallback? onTogglePromoCode;
  final TextEditingController? promoController;
  final VoidCallback? onApplyPromo;
  final String? promoError;
  final double? discount;

  const CartSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.onCheckout,
    this.showPromoCode = false,
    this.onTogglePromoCode,
    this.promoController,
    this.onApplyPromo,
    this.promoError,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                _buildSummaryHeader(theme),
                SizedBox(height: 3.h),
                _buildSummaryRow(theme, 'Subtotal', subtotal),
                if (discount != null && discount! > 0)
                  _buildSummaryRow(theme, 'Discount', -discount!,
                      isDiscount: true),
                _buildSummaryRow(theme, 'Tax', tax),
                _buildSummaryRow(theme, 'Shipping', shipping),
                Divider(
                  height: 3.h,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                _buildTotalRow(theme),
                if (showPromoCode) ...[
                  SizedBox(height: 2.h),
                  _buildPromoCodeSection(theme),
                ],
                SizedBox(height: 3.h),
                _buildCheckoutButton(theme),
              ],
            ),
          ),
          if (!showPromoCode) _buildPromoCodeToggle(theme),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order Summary',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Secure',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, double amount,
      {bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            isDiscount
                ? '-\$${amount.abs().toStringAsFixed(2)}'
                : '\$${amount.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDiscount
                  ? AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light)
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCodeSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: promoError != null
              ? theme.colorScheme.error
              : theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: promoController,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: onApplyPromo,
                child: Text('Apply'),
              ),
            ],
          ),
          if (promoError != null) ...[
            SizedBox(height: 1.h),
            Text(
              promoError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPromoCodeToggle(ThemeData theme) {
    return GestureDetector(
      onTap: onTogglePromoCode,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'local_offer',
              color: theme.colorScheme.primary,
              size: 18,
            ),
            SizedBox(width: 2.w),
            Text(
              'Have a promo code?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: theme.colorScheme.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'lock',
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Proceed to Checkout',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
