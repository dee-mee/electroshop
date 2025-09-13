import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final List<String> suggestions;
  final List<String> recentSearches;
  final ValueChanged<String> onSuggestionTap;
  final ValueChanged<String> onRecentSearchTap;
  final VoidCallback onClearRecentSearches;

  const SearchSuggestionsWidget({
    super.key,
    required this.suggestions,
    required this.recentSearches,
    required this.onSuggestionTap,
    required this.onRecentSearchTap,
    required this.onClearRecentSearches,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (suggestions.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Suggestions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  leading: CustomIconWidget(
                    iconName: 'search',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  title: Text(
                    suggestion,
                    style: theme.textTheme.bodyMedium,
                  ),
                  onTap: () => onSuggestionTap(suggestion),
                );
              },
            ),
          ],
          if (recentSearches.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClearRecentSearches,
                    child: Text(
                      'Clear All',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentSearches.length,
              itemBuilder: (context, index) {
                final search = recentSearches[index];
                return ListTile(
                  leading: CustomIconWidget(
                    iconName: 'history',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  title: Text(
                    search,
                    style: theme.textTheme.bodyMedium,
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      // Remove individual recent search
                    },
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                  ),
                  onTap: () => onRecentSearchTap(search),
                );
              },
            ),
          ],
          if (suggestions.isEmpty && recentSearches.isEmpty)
            _buildEmptyState(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'electrical_services',
            color: theme.colorScheme.primary,
            size: 15.w,
          ),
          SizedBox(height: 3.h),
          Text(
            'Popular Categories',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              'Lighting',
              'Wiring',
              'Switches',
              'Outlets',
              'Breakers',
              'Tools',
            ]
                .map((category) => GestureDetector(
                      onTap: () => onSuggestionTap(category),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.h),
                          border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          category,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
