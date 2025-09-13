import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedProductsGridWidget extends StatelessWidget {
  final int selectedCategoryIndex;

  const FeaturedProductsGridWidget({
    super.key,
    required this.selectedCategoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/product-search');
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return _buildProductCard(context, product);
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product-detail');
      },
      onLongPress: () {
        _showQuickActions(context, product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomImageWidget(
                      imageUrl: product["image"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (product["discount"] != null)
                    Positioned(
                      top: 1.h,
                      left: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product["discount"]}% OFF',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 1.h,
                    right: 2.w,
                    child: GestureDetector(
                      onTap: () {
                        _toggleWishlist(product);
                      },
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: (product["isWishlisted"] as bool)
                              ? 'favorite'
                              : 'favorite_border',
                          color: (product["isWishlisted"] as bool)
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["name"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${product["rating"]} (${product["reviews"]})',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product["originalPrice"] != null)
                              Text(
                                product["originalPrice"] as String,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            Text(
                              product["price"] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _addToCart(context, product);
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'add_shopping_cart',
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
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

  List<Map<String, dynamic>> _getFilteredProducts() {
    final allProducts = [
      {
        "id": 1,
        "name": "iPhone 15 Pro Max",
        "price": "KSH 155030.70",
        "originalPrice": "KSH 167960.70",
        "discount": 8,
        "rating": 4.8,
        "reviews": 1247,
        "image":
            "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=400&q=80",
        "category": 1,
        "isWishlisted": false,
      },
      {
        "id": 2,
        "name": "Sony WH-1000XM5 Headphones",
        "price": "KSH 45273.71",
        "originalPrice": "KSH 51718.71",
        "discount": 12,
        "rating": 4.7,
        "reviews": 892,
        "image":
            "https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg?auto=compress&cs=tinysrgb&w=400",
        "category": 2,
        "isWishlisted": true,
      },
      {
        "id": 3,
        "name": "Philips LED Smart Bulb",
        "price": "KSH 3231.21",
        "rating": 4.5,
        "reviews": 456,
        "image":
            "https://images.pixabay.com/photo/2017/08/30/12/45/girl-2696947_1280.jpg",
        "category": 3,
        "isWishlisted": false,
      },
      {
        "id": 4,
        "name": "12 AWG Copper Wire 100ft",
        "price": "KSH 11637.71",
        "rating": 4.6,
        "reviews": 234,
        "image":
            "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=400&q=80",
        "category": 4,
        "isWishlisted": false,
      },
      {
        "id": 5,
        "name": "Arduino Uno R3 Board",
        "price": "KSH 4202.25",
        "rating": 4.9,
        "reviews": 1567,
        "image":
            "https://images.pexels.com/photos/2582937/pexels-photo-2582937.jpeg?auto=compress&cs=tinysrgb&w=400",
        "category": 5,
        "isWishlisted": false,
      },
      {
        "id": 6,
        "name": "Circuit Breaker 20A",
        "price": "KSH 5818.50",
        "rating": 4.4,
        "reviews": 178,
        "image":
            "https://images.pixabay.com/photo/2016/11/30/20/58/programming-1873854_1280.png",
        "category": 6,
        "isWishlisted": true,
      },
      {
        "id": 7,
        "name": "Samsung Galaxy S24 Ultra",
        "price": "KSH 142268.71",
        "originalPrice": "KSH 155248.71",
        "discount": 8,
        "rating": 4.7,
        "reviews": 923,
        "image":
            "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=400&q=80",
        "category": 1,
        "isWishlisted": false,
      },
      {
        "id": 8,
        "name": "LED Strip Lights 16ft",
        "price": "KSH 2584.71",
        "originalPrice": "KSH 3877.71",
        "discount": 33,
        "rating": 4.3,
        "reviews": 678,
        "image":
            "https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg?auto=compress&cs=tinysrgb&w=400",
        "category": 3,
        "isWishlisted": false,
      },
    ];

    if (selectedCategoryIndex == 0) {
      return allProducts;
    }

    return (allProducts as List)
        .where((product) =>
            (product as Map<String, dynamic>)["category"] ==
            selectedCategoryIndex)
        .toList()
        .cast<Map<String, dynamic>>();
  }

  void _toggleWishlist(Map<String, dynamic> product) {
    // Toggle wishlist status - in real app, this would update backend
    product["isWishlisted"] = !(product["isWishlisted"] as bool);
  }

  void _addToCart(BuildContext context, Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product["name"]} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            Navigator.pushNamed(context, '/shopping-cart');
          },
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showQuickActions(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: (product["isWishlisted"] as bool)
                    ? 'favorite'
                    : 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text((product["isWishlisted"] as bool)
                  ? 'Remove from Wishlist'
                  : 'Add to Wishlist'),
              onTap: () {
                _toggleWishlist(product);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share Product'),
              onTap: () {
                Navigator.pop(context);
                // Share functionality would be implemented here
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'compare_arrows',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: const Text('View Similar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/product-search');
              },
            ),
          ],
        ),
      ),
    );
  }
}
