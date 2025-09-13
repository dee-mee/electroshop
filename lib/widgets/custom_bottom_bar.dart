import 'package:flutter/material.dart';

/// Custom bottom navigation bar for electrical retail mobile commerce application
/// Provides efficient navigation between main app sections with professional styling
class CustomBottomBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Callback when tab is tapped
  final ValueChanged<int> onTap;

  /// Type of bottom bar to display
  final CustomBottomBarType type;

  /// Whether to show labels
  final bool showLabels;

  /// Cart item count for badge display
  final int cartItemCount;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.type = CustomBottomBarType.standard,
    this.showLabels = true,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (type) {
      case CustomBottomBarType.floating:
        return _buildFloatingBottomBar(context);
      case CustomBottomBarType.minimal:
        return _buildMinimalBottomBar(context);
      default:
        return _buildStandardBottomBar(context);
    }
  }

  Widget _buildStandardBottomBar(BuildContext context) {
    final theme = Theme.of(context);

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
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _handleTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant,
        showSelectedLabels: showLabels,
        showUnselectedLabels: showLabels,
        elevation: 0,
        items: _buildBottomNavItems(context),
      ),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _handleTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant,
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          elevation: 0,
          items: _buildBottomNavItems(context),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildMinimalNavItems(context),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavItems(BuildContext context) {
    final theme = Theme.of(context);

    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.dashboard_outlined),
        activeIcon: const Icon(Icons.dashboard),
        label: 'Dashboard',
        tooltip: 'Product Dashboard',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.search_outlined),
        activeIcon: const Icon(Icons.search),
        label: 'Search',
        tooltip: 'Search Products',
      ),
      BottomNavigationBarItem(
        icon: Stack(
          children: [
            const Icon(Icons.shopping_cart_outlined),
            if (cartItemCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    cartItemCount > 9 ? '9+' : cartItemCount.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onError,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        activeIcon: Stack(
          children: [
            const Icon(Icons.shopping_cart),
            if (cartItemCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    cartItemCount > 9 ? '9+' : cartItemCount.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onError,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        label: 'Cart',
        tooltip: 'Shopping Cart',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.account_circle_outlined),
        activeIcon: const Icon(Icons.account_circle),
        label: 'Profile',
        tooltip: 'User Profile',
      ),
    ];
  }

  List<Widget> _buildMinimalNavItems(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      _MinimalNavItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        isActive: currentIndex == 0,
        onTap: () => _handleTap(0),
        theme: theme,
      ),
      _MinimalNavItem(
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        isActive: currentIndex == 1,
        onTap: () => _handleTap(1),
        theme: theme,
      ),
      _MinimalNavItem(
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart,
        isActive: currentIndex == 2,
        onTap: () => _handleTap(2),
        theme: theme,
        badge: cartItemCount > 0 ? cartItemCount : null,
      ),
      _MinimalNavItem(
        icon: Icons.account_circle_outlined,
        activeIcon: Icons.account_circle,
        isActive: currentIndex == 3,
        onTap: () => _handleTap(3),
        theme: theme,
      ),
    ];

    return items;
  }

  void _handleTap(int index) {
    // Navigate to appropriate route based on index
    final routes = [
      '/product-dashboard',
      '/product-search',
      '/shopping-cart',
      '/user-profile',
    ];

    onTap(index);

    // Get current context for navigation
    // Note: In a real implementation, you would pass BuildContext or use a navigation service
  }
}

/// Minimal navigation item widget for clean bottom bar
class _MinimalNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;
  final ThemeData theme;
  final int? badge;

  const _MinimalNavItem({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
    required this.theme,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            if (badge != null)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    badge! > 9 ? '9+' : badge.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onError,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Enum defining different types of bottom navigation bars
enum CustomBottomBarType {
  /// Standard bottom navigation bar
  standard,

  /// Floating bottom navigation bar with rounded corners
  floating,

  /// Minimal bottom navigation bar with clean design
  minimal,
}
