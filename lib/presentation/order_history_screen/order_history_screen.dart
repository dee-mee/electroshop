import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/order_card_widget.dart';
import './widgets/order_details_widget.dart';
import './widgets/order_filter_widget.dart';
import './widgets/order_search_widget.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allOrders = [];
  List<Map<String, dynamic>> _filteredOrders = [];
  String _selectedFilter = 'All';
  DateTimeRange? _dateRange;
  String _selectedCategory = 'All Categories';

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadOrderHistory() {
    // Mock electrical orders data
    _allOrders = [
      {
        "id": "ORD-2024-001",
        "orderNumber": "ORD-2024-001",
        "date": DateTime.now().subtract(Duration(days: 2)),
        "status": "Delivered",
        "statusColor": Colors.green,
        "total": 245.89,
        "itemCount": 3,
        "primaryImage":
            "https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg?auto=compress&cs=tinysrgb&w=800",
        "primaryItem": "LED Smart Bulb 60W",
        "shippingAddress": "123 Main St, Anytown, ST 12345",
        "paymentMethod": "Credit Card ****1234",
        "trackingNumber": "1Z999AA1012345675",
        "items": [
          {
            "name": "LED Smart Bulb 60W",
            "specifications": "Dimmable, WiFi Enabled",
            "quantity": 4,
            "price": 3231.21,
            "image":
                "https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg?auto=compress&cs=tinysrgb&w=800",
            "category": "Lighting"
          },
          {
            "name": "GFCI Outlet 20A",
            "specifications": "Tamper Resistant, White",
            "quantity": 2,
            "price": 2455.41,
            "image":
                "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
            "category": "Switches & Outlets"
          },
          {
            "name": "Digital Multimeter",
            "specifications": "Auto-ranging, True RMS",
            "quantity": 1,
            "price": 5948.31,
            "image":
                "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
            "category": "Tools & Equipment"
          }
        ]
      },
      {
        "id": "ORD-2024-002",
        "orderNumber": "ORD-2024-002",
        "date": DateTime.now().subtract(Duration(days: 5)),
        "status": "Shipped",
        "statusColor": Colors.orange,
        "total": 189.50,
        "itemCount": 2,
        "primaryImage":
            "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
        "primaryItem": "12 AWG Copper Wire",
        "shippingAddress": "123 Main St, Anytown, ST 12345",
        "paymentMethod": "Credit Card ****1234",
        "trackingNumber": "1Z999AA1012345676",
        "items": [
          {
            "name": "12 AWG Copper Wire",
            "specifications": "THHN/THWN-2, 500ft Roll",
            "quantity": 2,
            "price": 11637.71,
            "image":
                "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
            "category": "Wiring & Cables"
          },
          {
            "name": "Wire Nuts Assorted",
            "specifications": "Pack of 100",
            "quantity": 1,
            "price": 1230.44,
            "image":
                "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
            "category": "Wiring & Cables"
          }
        ]
      },
      {
        "id": "ORD-2024-003",
        "orderNumber": "ORD-2024-003",
        "date": DateTime.now().subtract(Duration(days: 10)),
        "status": "Processing",
        "statusColor": Colors.blue,
        "total": 567.23,
        "itemCount": 5,
        "primaryImage":
            "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
        "primaryItem": "Circuit Breaker Panel",
        "shippingAddress": "456 Oak Ave, Another City, ST 54321",
        "paymentMethod": "Business Account",
        "trackingNumber": null,
        "items": [
          {
            "name": "Circuit Breaker Panel",
            "specifications": "200A Main Breaker",
            "quantity": 1,
            "price": 38786.71,
            "image":
                "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
            "category": "Circuit Breakers"
          },
          {
            "name": "Circuit Breaker 20A",
            "specifications": "Single Pole, QO Series",
            "quantity": 10,
            "price": 1679.61,
            "image":
                "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
            "category": "Circuit Breakers"
          }
        ]
      },
      {
        "id": "ORD-2023-045",
        "orderNumber": "ORD-2023-045",
        "date": DateTime.now().subtract(Duration(days: 45)),
        "status": "Cancelled",
        "statusColor": Colors.red,
        "total": 75.98,
        "itemCount": 1,
        "primaryImage":
            "https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg?auto=compress&cs=tinysrgb&w=800",
        "primaryItem": "LED Panel Light 2x4",
        "shippingAddress": "123 Main St, Anytown, ST 12345",
        "paymentMethod": "Credit Card ****1234",
        "trackingNumber": null,
        "items": [
          {
            "name": "LED Panel Light 2x4",
            "specifications": "40W, 5000K, Edge-lit",
            "quantity": 2,
            "price": 4524.21,
            "image":
                "https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg?auto=compress&cs=tinysrgb&w=800",
            "category": "Lighting"
          }
        ]
      }
    ];

    setState(() {
      _filteredOrders = List.from(_allOrders);
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredOrders = _allOrders.where((order) {
        // Status filter
        if (_selectedFilter != 'All' && order['status'] != _selectedFilter) {
          return false;
        }

        // Date range filter
        if (_dateRange != null) {
          final orderDate = order['date'] as DateTime;
          if (orderDate.isBefore(_dateRange!.start) ||
              orderDate.isAfter(_dateRange!.end.add(Duration(days: 1)))) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategory != 'All Categories') {
          final items = order['items'] as List<Map<String, dynamic>>;
          final hasCategory =
              items.any((item) => item['category'] == _selectedCategory);
          if (!hasCategory) {
            return false;
          }
        }

        // Search filter
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          final orderNumber = order['orderNumber'].toString().toLowerCase();
          final primaryItem = order['primaryItem'].toString().toLowerCase();
          final items = order['items'] as List<Map<String, dynamic>>;

          final matchesOrder = orderNumber.contains(query);
          final matchesPrimary = primaryItem.contains(query);
          final matchesItems = items.any((item) =>
              item['name'].toString().toLowerCase().contains(query) ||
              item['specifications'].toString().toLowerCase().contains(query));

          if (!matchesOrder && !matchesPrimary && !matchesItems) {
            return false;
          }
        }

        return true;
      }).toList();

      // Sort by date (newest first)
      _filteredOrders.sort(
          (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderFilterWidget(
        selectedFilter: _selectedFilter,
        selectedCategory: _selectedCategory,
        dateRange: _dateRange,
        onFilterChanged: (filter, category, dateRange) {
          setState(() {
            _selectedFilter = filter;
            _selectedCategory = category;
            _dateRange = dateRange;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsWidget(
        order: order,
        onReorder: () => _handleReorder(order),
        onTrackPackage: () => _handleTrackPackage(order),
        onReturnItems: () => _handleReturnItems(order),
        onDownloadInvoice: () => _handleDownloadInvoice(order),
      ),
    );
  }

  void _handleReorder(Map<String, dynamic> order) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Items added to cart for reorder'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleTrackPackage(Map<String, dynamic> order) {
    Navigator.pop(context);
    if (order['trackingNumber'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening tracking: ${order['trackingNumber']}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tracking information not available'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _handleReturnItems(Map<String, dynamic> order) {
    Navigator.pop(context);
    if (order['status'] == 'Delivered') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Return process initiated for ${order['orderNumber']}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Returns only available for delivered orders'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _handleDownloadInvoice(Map<String, dynamic> order) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading invoice for ${order['orderNumber']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
                  "https://images.pexels.com/photos/5858532/pexels-photo-5858532.jpeg?auto=compress&cs=tinysrgb&w=400",
              height: 40.w,
              width: 40.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            Text(
              'No Orders Found',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No orders match your search criteria.\nTry adjusting your filters or search terms.'
                  : 'Start shopping for electrical supplies\nto see your order history here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.productDashboard, (route) => false);
              },
              icon: CustomIconWidget(
                iconName: 'shopping_cart',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Start Shopping'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'tune',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          OrderSearchWidget(
            searchController: _searchController,
            onSearchChanged: (query) {
              _applyFilters();
            },
            selectedFilter: _selectedFilter,
            selectedCategory: _selectedCategory,
            dateRange: _dateRange,
            onClearFilters: () {
              setState(() {
                _selectedFilter = 'All';
                _selectedCategory = 'All Categories';
                _dateRange = null;
                _searchController.clear();
              });
              _applyFilters();
            },
          ),
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                      _loadOrderHistory();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order history updated'),
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      );
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = _filteredOrders[index];
                        return OrderCardWidget(
                          order: order,
                          onTap: () => _showOrderDetails(order),
                          onReorder: () => _handleReorder(order),
                          onTrackPackage: () => _handleTrackPackage(order),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}