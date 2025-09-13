import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductInfoSection extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = (product['rating'] as num?)?.toDouble() ?? 0.0;
    final reviewCount = product['reviewCount'] as int? ?? 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name and wishlist
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product['name'] as String? ?? 'Product Name',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: onWishlistToggle,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isWishlisted
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: isWishlisted ? 'favorite' : 'favorite_border',
                    size: 24,
                    color: isWishlisted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Brand
          if (product['brand'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                product['brand'] as String,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          SizedBox(height: 2.h),

          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product['price'] as String? ?? 'KSH 0.00',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (product['originalPrice'] != null) ...[
                SizedBox(width: 2.w),
                Text(
                  product['originalPrice'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (product['discount'] != null) ...[
                SizedBox(width: 2.w),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor(
                        theme.brightness == Brightness.light),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${product['discount']}% OFF',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 2.h),

          // Rating and reviews
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: index < rating.floor() ? 'star' : 'star_border',
                    size: 20,
                    color: index < rating.floor()
                        ? AppTheme.getWarningColor(
                            theme.brightness == Brightness.light)
                        : theme.colorScheme.onSurfaceVariant,
                  );
                }),
              ),
              SizedBox(width: 2.w),
              Text(
                rating.toStringAsFixed(1),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                '($reviewCount reviews)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Stock status
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: (product['inStock'] as bool? ?? true)
                      ? AppTheme.getSuccessColor(
                          theme.brightness == Brightness.light)
                      : theme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                (product['inStock'] as bool? ?? true)
                    ? 'In Stock'
                    : 'Out of Stock',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: (product['inStock'] as bool? ?? true)
                      ? AppTheme.getSuccessColor(
                          theme.brightness == Brightness.light)
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (product['stockCount'] != null) ...[
                SizedBox(width: 2.w),
                Text(
                  '(${product['stockCount']} available)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
