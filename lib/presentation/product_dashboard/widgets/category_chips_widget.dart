import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryChipsWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategoryChipsWidget({
    super.key,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  final List<Map<String, dynamic>> _categories = const [
    {
      "id": 0,
      "name": "All",
      "icon": "apps",
      "color": Color(0xFF1565C0),
    },
    {
      "id": 1,
      "name": "Phones",
      "icon": "smartphone",
      "color": Color(0xFF37474F),
    },
    {
      "id": 2,
      "name": "Audio",
      "icon": "headphones",
      "color": Color(0xFFFF6F00),
    },
    {
      "id": 3,
      "name": "Lighting",
      "icon": "lightbulb",
      "color": Color(0xFFF57C00),
    },
    {
      "id": 4,
      "name": "Wiring",
      "icon": "cable",
      "color": Color(0xFF388E3C),
    },
    {
      "id": 5,
      "name": "Components",
      "icon": "memory",
      "color": Color(0xFFD32F2F),
    },
    {
      "id": 6,
      "name": "Protection",
      "icon": "security",
      "color": Color(0xFF7B1FA2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? (category["color"] as Color)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (category["color"] as Color)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (category["color"] as Color)
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: category["icon"] as String,
                    color: isSelected
                        ? Colors.white
                        : (category["color"] as Color),
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    category["name"] as String,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
