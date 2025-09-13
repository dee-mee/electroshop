import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String currentSort;
  final ValueChanged<String> onSortChanged;

  const SortBottomSheetWidget({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  static const List<Map<String, String>> _sortOptions = [
    {
      'key': 'relevance',
      'label': 'Relevance',
      'description': 'Best match for your search'
    },
    {
      'key': 'price_low',
      'label': 'Price: Low to High',
      'description': 'Lowest price first'
    },
    {
      'key': 'price_high',
      'label': 'Price: High to Low',
      'description': 'Highest price first'
    },
    {
      'key': 'rating',
      'label': 'Customer Rating',
      'description': 'Highest rated first'
    },
    {
      'key': 'newest',
      'label': 'Newest Arrivals',
      'description': 'Recently added products'
    },
    {
      'key': 'popular',
      'label': 'Most Popular',
      'description': 'Frequently purchased'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sortOptions.length,
            separatorBuilder: (context, index) => Divider(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final option = _sortOptions[index];
              final isSelected = currentSort == option['key'];

              return ListTile(
                leading: CustomIconWidget(
                  iconName: _getSortIcon(option['key']!),
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                title: Text(
                  option['label']!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                subtitle: Text(
                  option['description']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: isSelected
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: theme.colorScheme.primary,
                        size: 5.w,
                      )
                    : null,
                onTap: () {
                  onSortChanged(option['key']!);
                  Navigator.pop(context);
                },
              );
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sort by',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  String _getSortIcon(String sortKey) {
    switch (sortKey) {
      case 'relevance':
        return 'search';
      case 'price_low':
        return 'arrow_upward';
      case 'price_high':
        return 'arrow_downward';
      case 'rating':
        return 'star';
      case 'newest':
        return 'new_releases';
      case 'popular':
        return 'trending_up';
      default:
        return 'sort';
    }
  }
}
