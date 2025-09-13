import 'package:flutter/material.dart';

/// Custom tab bar widget for electrical retail mobile commerce application
/// Provides efficient category navigation and filtering with professional styling
class CustomTabBar extends StatelessWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Currently selected tab index
  final int selectedIndex;

  /// Callback when tab is tapped
  final ValueChanged<int> onTap;

  /// Type of tab bar to display
  final CustomTabBarType type;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Tab controller for external control
  final TabController? controller;

  /// Whether to show tab indicators
  final bool showIndicator;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom tab padding
  final EdgeInsets? tabPadding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.type = CustomTabBarType.standard,
    this.isScrollable = true,
    this.controller,
    this.showIndicator = true,
    this.indicatorColor,
    this.tabPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case CustomTabBarType.chips:
        return _buildChipTabBar(context);
      case CustomTabBarType.segmented:
        return _buildSegmentedTabBar(context);
      case CustomTabBarType.minimal:
        return _buildMinimalTabBar(context);
      default:
        return _buildStandardTabBar(context);
    }
  }

  Widget _buildStandardTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        onTap: onTap,
        isScrollable: isScrollable,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        labelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        indicatorColor: showIndicator
            ? (indicatorColor ?? theme.colorScheme.primary)
            : Colors.transparent,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        padding: tabPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
      ),
    );
  }

  Widget _buildChipTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                tabs[index],
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;
          final isFirst = index == 0;
          final isLast = index == tabs.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: isFirst ? const Radius.circular(7) : Radius.zero,
                    bottomLeft:
                        isFirst ? const Radius.circular(7) : Radius.zero,
                    topRight: isLast ? const Radius.circular(7) : Radius.zero,
                    bottomRight:
                        isLast ? const Radius.circular(7) : Radius.zero,
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMinimalTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tabs[index],
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                if (showIndicator)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: isSelected ? 24 : 0,
                    decoration: BoxDecoration(
                      color: indicatorColor ?? theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Custom tab bar specifically for product categories
class CustomProductCategoryTabBar extends StatelessWidget {
  /// Currently selected category index
  final int selectedIndex;

  /// Callback when category is tapped
  final ValueChanged<int> onTap;

  /// Type of tab bar to display
  final CustomTabBarType type;

  const CustomProductCategoryTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.type = CustomTabBarType.chips,
  });

  static const List<String> _categories = [
    'All',
    'Wiring',
    'Lighting',
    'Outlets',
    'Switches',
    'Breakers',
    'Tools',
    'Safety',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: _categories,
      selectedIndex: selectedIndex,
      onTap: onTap,
      type: type,
      isScrollable: true,
    );
  }
}

/// Custom tab bar for product filters
class CustomProductFilterTabBar extends StatelessWidget {
  /// Currently selected filter index
  final int selectedIndex;

  /// Callback when filter is tapped
  final ValueChanged<int> onTap;

  /// Type of tab bar to display
  final CustomTabBarType type;

  const CustomProductFilterTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.type = CustomTabBarType.segmented,
  });

  static const List<String> _filters = [
    'Popular',
    'Price: Low',
    'Price: High',
    'Rating',
    'New',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: _filters,
      selectedIndex: selectedIndex,
      onTap: onTap,
      type: type,
      isScrollable: false,
    );
  }
}

/// Enum defining different types of tab bars
enum CustomTabBarType {
  /// Standard tab bar with underline indicator
  standard,

  /// Chip-style tab bar with rounded borders
  chips,

  /// Segmented control style tab bar
  segmented,

  /// Minimal tab bar with clean design
  minimal,
}
