import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RelatedProductsSection extends StatelessWidget {
  final String currentProductId;

  const RelatedProductsSection({
    super.key,
    required this.currentProductId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Related Products',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/product-search');
                  },
                  child: Text(
                    'View All',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 35.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _relatedProducts.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final product = _relatedProducts[index];
                return _RelatedProductCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-detail',
                      arguments: {'productId': product['id']},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _relatedProducts = [
    {
      'id': 'rel_001',
      'name': 'Smart LED Bulb 9W',
      'brand': 'Philips',
      'price': 'KSH 3231.21',
      'originalPrice': 'KSH 3877.71',
      'discount': 17,
      'rating': 4.3,
      'reviewCount': 156,
      'image':
          'https://images.pexels.com/photos/1112598/pexels-photo-1112598.jpeg?auto=compress&cs=tinysrgb&w=400',
      'inStock': true,
    },
    {
      'id': 'rel_002',
      'name': 'Wall Switch Dimmer',
      'brand': 'Leviton',
      'price': 'KSH 2392.05',
      'rating': 4.6,
      'reviewCount': 89,
      'image':
          'https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=400',
      'inStock': true,
    },
    {
      'id': 'rel_003',
      'name': 'USB Wall Outlet',
      'brand': 'Legrand',
      'price': 'KSH 4235.93',
      'rating': 4.4,
      'reviewCount': 203,
      'image':
          'https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=400',
      'inStock': false,
    },
    {
      'id': 'rel_004',
      'name': 'Circuit Breaker 20A',
      'brand': 'Square D',
      'price': 'KSH 5948.31',
      'rating': 4.8,
      'reviewCount': 67,
      'image':
          'https://images.pixabay.com/photo-2016/11/19/15/32/electricity-1840313_640.jpg',
      'inStock': true,
    },
    {
      'id': 'rel_005',
      'name': 'Extension Cord 25ft',
      'brand': 'Coleman Cable',
      'price': 'KSH 3748.41',
      'originalPrice': 'KSH 4524.21',
      'discount': 17,
      'rating': 4.2,
      'reviewCount': 134,
      'image':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=400&q=60',
      'inStock': true,
    },
  ];
}

class _RelatedProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _RelatedProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = (product['rating'] as num?)?.toDouble() ?? 0.0;
    final reviewCount = product['reviewCount'] as int? ?? 0;
    final inStock = product['inStock'] as bool? ?? true;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: 20.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: CustomImageWidget(
                      imageUrl: product['image'] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Discount badge
                  if (product['discount'] != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
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
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                  // Stock status
                  if (!inStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Out of Stock',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    if (product['brand'] != null)
                      Text(
                        product['brand'] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    SizedBox(height: 0.5.h),

                    // Product name
                    Text(
                      product['name'] as String? ?? 'Product Name',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Rating
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          size: 14,
                          color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '($reviewCount)',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price
                    Row(
                      children: [
                        Text(
                          product['price'] as String? ?? 'KSH 0.00',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (product['originalPrice'] != null) ...[
                          SizedBox(width: 2.w),
                          Text(
                            product['originalPrice'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
