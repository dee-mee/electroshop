import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar widget for electrical retail mobile commerce application
/// Provides professional presentation with contextual actions and search functionality
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Type of app bar to display
  final CustomAppBarType type;

  /// Title text to display
  final String? title;

  /// Whether to show the back button
  final bool showBackButton;

  /// Whether to show the search action
  final bool showSearch;

  /// Whether to show the cart action
  final bool showCart;

  /// Whether to show the barcode scanner action
  final bool showBarcodeScanner;

  /// Cart item count for badge display
  final int cartItemCount;

  /// Custom actions to display
  final List<Widget>? actions;

  /// Search query callback
  final ValueChanged<String>? onSearchChanged;

  /// Search submit callback
  final ValueChanged<String>? onSearchSubmitted;

  /// Whether search is currently active
  final bool isSearchActive;

  /// Search controller for external control
  final TextEditingController? searchController;

  const CustomAppBar({
    super.key,
    this.type = CustomAppBarType.standard,
    this.title,
    this.showBackButton = true,
    this.showSearch = false,
    this.showCart = false,
    this.showBarcodeScanner = false,
    this.cartItemCount = 0,
    this.actions,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.isSearchActive = false,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      leading: _buildLeading(context),
      title: _buildTitle(context),
      actions: _buildActions(context),
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: type == CustomAppBarType.elevated ? 4.0 : 2.0,
      surfaceTintColor: Colors.transparent,
      centerTitle: type == CustomAppBarType.centered,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!showBackButton) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    if (isSearchActive && type == CustomAppBarType.search) {
      return _buildSearchField(context);
    }

    switch (type) {
      case CustomAppBarType.logo:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.electrical_services,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title ?? 'ElectroMart',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        );
      case CustomAppBarType.search:
        return _buildSearchField(context);
      default:
        return Text(
          title ?? '',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        onSubmitted: onSearchSubmitted,
        decoration: InputDecoration(
          hintText: 'Search products, parts...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: isSearchActive
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () {
                    searchController?.clear();
                    onSearchChanged?.call('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> actionWidgets = [];

    // Search action
    if (showSearch && type != CustomAppBarType.search) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => Navigator.pushNamed(context, '/product-search'),
          tooltip: 'Search',
        ),
      );
    }

    // Barcode scanner action
    if (showBarcodeScanner) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: () {
            // TODO: Implement barcode scanning functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Barcode scanner feature coming soon'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          tooltip: 'Scan Barcode',
        ),
      );
    }

    // Cart action with badge
    if (showCart) {
      actionWidgets.add(
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.pushNamed(context, '/shopping-cart'),
              tooltip: 'Shopping Cart',
            ),
            if (cartItemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    cartItemCount > 99 ? '99+' : cartItemCount.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Custom actions
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    // Profile action (always show)
    actionWidgets.add(
      IconButton(
        icon: const Icon(Icons.account_circle_outlined),
        onPressed: () => Navigator.pushNamed(context, '/user-profile'),
        tooltip: 'Profile',
      ),
    );

    return actionWidgets;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Enum defining different types of app bars
enum CustomAppBarType {
  /// Standard app bar with title
  standard,

  /// App bar with logo and brand name
  logo,

  /// App bar with integrated search field
  search,

  /// Centered title app bar
  centered,

  /// Elevated app bar with higher shadow
  elevated,
}
