import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/product_image_gallery.dart';
import './widgets/product_info_section.dart';
import './widgets/product_tabs_section.dart';
import './widgets/related_products_section.dart';
import './widgets/sticky_bottom_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _isWishlisted = false;
  bool _isOfflineMode = false;
  late ScrollController _scrollController;
  bool _showStickyHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _checkConnectivity();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 200;
    if (shouldShow != _showStickyHeader) {
      setState(() {
        _showStickyHeader = shouldShow;
      });
    }
  }

  void _checkConnectivity() {
    // Simulate offline mode check
    setState(() {
      _isOfflineMode = false; // Set to true to test offline mode
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final productId = arguments?['productId'] as String? ?? 'default_product';
    final product = _getProductData(productId);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App bar with hero image
              SliverAppBar(
                expandedHeight: 50.h,
                pinned: true,
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: theme.colorScheme.onSurface,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      size: 24,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'share',
                        size: 24,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => _shareProduct(context, product),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ProductImageGallery(
                    images: (product['images'] as List<dynamic>).cast<String>(),
                    heroTag: 'product_$productId',
                  ),
                ),
              ),

              // Product information
              SliverToBoxAdapter(
                child: ProductInfoSection(
                  product: product,
                  isWishlisted: _isWishlisted,
                  onWishlistToggle: _toggleWishlist,
                ),
              ),

              // Offline indicator
              if (_isOfflineMode)
                SliverToBoxAdapter(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.getWarningColor(
                                theme.brightness == Brightness.light)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'wifi_off',
                          size: 20,
                          color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Offline Mode',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.getWarningColor(
                                      theme.brightness == Brightness.light),
                                ),
                              ),
                              Text(
                                'Showing cached product data. Some features may be limited.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'sync',
                          size: 16,
                          color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light),
                        ),
                      ],
                    ),
                  ),
                ),

              // Product tabs
              SliverToBoxAdapter(
                child: ProductTabsSection(product: product),
              ),

              // Related products
              SliverToBoxAdapter(
                child: RelatedProductsSection(
                  currentProductId: productId,
                ),
              ),

              // Bottom padding for sticky bar
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
            ],
          ),

          // Sticky bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StickyBottomBar(
              product: product,
              onAddToCart: () => _addToCart(context, product),
              onBuyNow: () => _buyNow(context, product),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getProductData(String productId) {
    // Mock product data - in real app, this would come from API or local storage
    return {
      'id': productId,
      'name': 'Smart WiFi Light Switch with Dimmer Control',
      'brand': 'Kasa Smart',
      'price': 'KSH 4524.21',
      'originalPrice': 'KSH 6463.71',
      'discount': 30,
      'rating': 4.6,
      'reviewCount': 1247,
      'inStock': true,
      'stockCount': 23,
      'images': [
        'https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=800&q=60',
        'https://images.pixabay.com/photo-2016/11/19/15/32/electricity-1840313_640.jpg',
        'https://images.pexels.com/photos/1112598/pexels-photo-1112598.jpeg?auto=compress&cs=tinysrgb&w=800',
      ],
      'description':
          '''Transform your home into a smart home with the Kasa Smart WiFi Light Switch. This innovative dimmer switch allows you to control your lights remotely using your smartphone or voice commands through Alexa or Google Assistant.

Key Features:
• Remote control via smartphone app
• Voice control compatibility with Alexa and Google Assistant
• Smooth dimming from 1% to 100%
• Schedule and timer functions
• Away mode for security
• No hub required - connects directly to your WiFi
• Easy installation with standard wiring
• Works with LED, CFL, and incandescent bulbs

Perfect for modern homes seeking convenience, energy efficiency, and enhanced security. The sleek design complements any décor while providing advanced lighting control at your fingertips.''',
      'keySpecs': [
        {'label': 'Voltage', 'value': '120V AC, 60Hz'},
        {'label': 'Load Capacity', 'value': '150W LED/CFL, 600W Incandescent'},
        {'label': 'Connectivity', 'value': '2.4GHz WiFi (802.11 b/g/n)'},
        {'label': 'Dimming Range', 'value': '1% - 100%'},
        {'label': 'Installation', 'value': 'Single-pole, 3-way compatible'},
        {'label': 'App Control', 'value': 'Kasa Smart App (iOS/Android)'},
      ],
      'technicalSpecs': [
        {'label': 'Input Voltage', 'value': '120V AC ± 10%, 60Hz'},
        {
          'label': 'Maximum Load',
          'value': '150W LED/CFL, 600W Incandescent/Halogen'
        },
        {'label': 'Minimum Load', 'value': '25W'},
        {
          'label': 'Operating Temperature',
          'value': '32°F to 104°F (0°C to 40°C)'
        },
        {'label': 'Humidity Range', 'value': '5% to 90% RH, non-condensing'},
        {'label': 'Wireless Standard', 'value': 'IEEE 802.11 b/g/n 2.4GHz'},
        {'label': 'Wireless Security', 'value': 'WEP/WPA/WPA2'},
        {
          'label': 'Dimensions',
          'value': '4.2" × 1.7" × 1.5" (106 × 43 × 38 mm)'
        },
        {'label': 'Weight', 'value': '3.5 oz (99g)'},
        {'label': 'Certification', 'value': 'FCC, UL Listed, Energy Star'},
        {'label': 'Warranty', 'value': '2 Years Limited'},
        {'label': 'Wire Gauge', 'value': '14 AWG - 12 AWG'},
      ],
      'reviews': [
        {
          'userName': 'Michael Chen',
          'rating': 5,
          'date': '2025-01-15',
          'comment':
              'Excellent smart switch! Installation was straightforward and the app works perfectly. Love being able to dim the lights from my phone and set schedules. Highly recommended for anyone upgrading to smart home.',
          'verified': true,
        },
        {
          'userName': 'Sarah Johnson',
          'rating': 4,
          'date': '2025-01-10',
          'comment':
              'Great product overall. The dimming feature works smoothly and voice control with Alexa is very convenient. Only minor issue is the app occasionally takes a few seconds to connect, but not a deal breaker.',
          'verified': true,
        },
        {
          'userName': 'David Rodriguez',
          'rating': 5,
          'date': '2025-01-08',
          'comment':
              'Perfect replacement for my old dimmer switch. The scheduling feature is fantastic - lights automatically turn on at sunset and off at bedtime. Installation took about 15 minutes following the clear instructions.',
          'verified': true,
        },
        {
          'userName': 'Emily Watson',
          'rating': 4,
          'date': '2025-01-05',
          'comment':
              'Works as advertised. The away mode gives me peace of mind when traveling. App interface is intuitive and setup was easy. Would buy again for other rooms.',
          'verified': true,
        },
        {
          'userName': 'James Miller',
          'rating': 5,
          'date': '2025-01-02',
          'comment':
              'Outstanding smart switch! The build quality feels premium and the dimming is very smooth without any flickering. Google Assistant integration works flawlessly. Worth every penny.',
          'verified': true,
        },
      ],
      'installationGuide': 'installation_guide.pdf',
    };
  }

  void _toggleWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isWishlisted ? 'Added to wishlist' : 'Removed from wishlist',
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Wishlist',
          onPressed: () {
            Navigator.pushNamed(context, '/user-profile');
          },
        ),
      ),
    );
  }

  void _shareProduct(BuildContext context, Map<String, dynamic> product) {
    final productName = product['name'] as String;
    final productPrice = product['price'] as String;
    final shareText = '''Check out this amazing electrical product!

$productName
Price: $productPrice

Key Features:
• Smart WiFi connectivity
• Voice control compatible
• Easy smartphone control
• Professional grade quality

Available now on ElectroShop - Your trusted electrical retailer!

#ElectroShop #SmartHome #ElectricalProducts''';

    // Copy to clipboard as a simple share implementation
    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              size: 20,
              color: AppTheme.getSuccessColor(
                  Theme.of(context).brightness == Brightness.light),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Product details copied to clipboard for sharing!'),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
      ),
    );
  }

  void _addToCart(BuildContext context, Map<String, dynamic> product) {
    // Cart addition logic would be implemented here
    // This is handled by the StickyBottomBar widget
  }

  void _buyNow(BuildContext context, Map<String, dynamic> product) {
    // Navigate directly to checkout
    Navigator.pushNamed(context, '/shopping-cart', arguments: {
      'directCheckout': true,
      'product': product,
    });
  }
}
