import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


class OrderFilterWidget extends StatefulWidget {
  final String selectedFilter;
  final String selectedCategory;
  final DateTimeRange? dateRange;
  final Function(String, String, DateTimeRange?) onFilterChanged;

  const OrderFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.selectedCategory,
    this.dateRange,
    required this.onFilterChanged,
  });

  @override
  State<OrderFilterWidget> createState() => _OrderFilterWidgetState();
}

class _OrderFilterWidgetState extends State<OrderFilterWidget> {
  late String _selectedFilter;
  late String _selectedCategory;
  DateTimeRange? _dateRange;

  final List<String> _statusFilters = [
    'All',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  final List<String> _categories = [
    'All Categories',
    'Lighting',
    'Wiring & Cables',
    'Switches & Outlets',
    'Circuit Breakers',
    'Tools & Equipment',
    'Extension Cords',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
    _selectedCategory = widget.selectedCategory;
    _dateRange = widget.dateRange;
  }

  void _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _applyFilters() {
    widget.onFilterChanged(_selectedFilter, _selectedCategory, _dateRange);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedFilter = 'All';
      _selectedCategory = 'All Categories';
      _dateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Filter Orders',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(
                      'Clear All',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Filter content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Status
                    Text(
                      'Order Status',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _statusFilters.map((status) {
                        final isSelected = _selectedFilter == status;
                        return Material(
                          child: FilterChip(
                            label: Text(status),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = status;
                              });
                            },
                            backgroundColor: theme.colorScheme.surfaceContainer,
                            selectedColor:
                                theme.colorScheme.primary.withValues(alpha: 0.1),
                            checkmarkColor: theme.colorScheme.primary,
                            labelStyle: theme.textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList().cast<Widget>(),
                    ),

                    SizedBox(height: 24),

                    // Product Category
                    Text(
                      'Product Category',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Material(
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            backgroundColor: theme.colorScheme.surfaceContainer,
                            selectedColor:
                                theme.colorScheme.primary.withValues(alpha: 0.1),
                            checkmarkColor: theme.colorScheme.primary,
                            labelStyle: theme.textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList().cast<Widget>(),
                    ),

                    SizedBox(height: 24),

                    // Date Range
                    Text(
                      'Order Date Range',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: _selectDateRange,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'date_range',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              _dateRange != null
                                  ? '${DateFormat('MMM dd, yyyy').format(_dateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(_dateRange!.end)}'
                                  : 'Select date range',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _dateRange != null
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Spacer(),
                            if (_dateRange != null)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _dateRange = null;
                                  });
                                },
                                child: CustomIconWidget(
                                  iconName: 'close',
                                  color: theme.colorScheme.error,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Apply button
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Apply Filters'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}