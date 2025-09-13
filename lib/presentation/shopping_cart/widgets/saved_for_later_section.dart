import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SavedForLaterSection extends StatelessWidget {
  final List<Map<String, dynamic>> savedItems;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final Function(Map<String, dynamic>) onMoveToCart;
  final Function(Map<String, dynamic>) onRemoveFromSaved;

  const SavedForLaterSection({
    super.key,
    required this.savedItems,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onMoveToCart,
    required this.onRemoveFromSaved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (savedItems.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          if (isExpanded) _buildSavedItemsList(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return GestureDetector(
      onTap: onToggleExpanded,
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'bookmark',
              color: theme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Saved for Later (${savedItems.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconWidget(
              iconName:
                  isExpanded ? 'keyboard_arrow_up' : 'keyboard_arrow_down',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedItemsList(ThemeData theme) {
    return Column(
      children: [
        Divider(
          height: 1,
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: savedItems.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          itemBuilder: (context, index) {
            final item = savedItems[index];
            return _buildSavedItem(theme, item);
          },
        ),
      ],
    );
  }

  Widget _buildSavedItem(ThemeData theme, Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: item['image'] as String? ?? '',
                width: 15.w,
                height: 15.w,
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
                  item['name'] as String? ?? 'Product Name',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'KSH${(item['price'] as double? ?? 0.0).toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              TextButton(
                onPressed: () => onMoveToCart(item),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  'Move to Cart',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => onRemoveFromSaved(item),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  'Remove',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
