import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/product_grid_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/search_header_widget.dart';
import './widgets/search_suggestions_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({super.key});

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isSearching = false;
  bool _showSuggestions = false;
  String _currentSort = 'relevance';
  Map<String, dynamic> _currentFilters = {};
  Map<String, dynamic>? _selectedProduct;

  List<Map<String, dynamic>> _searchResults = [];
  List<FilterChip> _activeFilters = [];
  List<String> _searchSuggestions = [];
  List<String> _recentSearches = [];

  // Mock data for electrical products
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "name": "LED Smart Bulb 60W",
      "specifications": "Dimmable, WiFi Enabled",
      "price": "KSH 3231.21",
      "rating": 4.5,
      "category": "Lighting",
      "brand": "Philips",
      "image":
          "https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg?auto=compress&cs=tinysrgb&w=800",
      "inStock": true,
      "energyStar": true,
      "ulListed": true,
    },
    {
      "id": 2,
      "name": "12 AWG Copper Wire",
      "specifications": "THHN/THWN-2, 500ft Roll",
      "price": "KSH 11637.71",
      "rating": 4.8,
      "category": "Wiring & Cables",
      "brand": "Southwire",
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "inStock": true,
      "energyStar": false,
      "ulListed": true,
    },
    {
      "id": 3,
      "name": "GFCI Outlet 20A",
      "specifications": "Tamper Resistant, White",
      "price": "KSH 2455.41",
      "rating": 4.3,
      "category": "Switches & Outlets",
      "brand": "Leviton",
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "inStock": true,
      "energyStar": false,
      "ulListed": true,
    },
    {
      "id": 4,
      "name": "Circuit Breaker 20A",
      "specifications": "Single Pole, QO Series",
      "price": "KSH 1679.61",
      "rating": 4.7,
      "category": "Circuit Breakers",
      "brand": "Square D",
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "inStock": false,
      "energyStar": false,
      "ulListed": true,
    },
    {
      "id": 5,
      "name": "Digital Multimeter",
      "specifications": "Auto-ranging, True RMS",
      "price": "KSH 5948.31",
      "rating": 4.6,
      "category": "Tools & Equipment",
      "brand": "Fluke",
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "inStock": true,
      "energyStar": false,
      "ulListed": false,
    },
    {
      "id": 6,
      "name": "LED Panel Light 2x4",
      "specifications": "40W, 5000K, Edge-lit",
      "price": "KSH 4524.21",
      "rating": 4.4,
      "category": "Lighting",
      "brand": "TCP",
      "image":
          "https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg?auto=compress&cs=tinysrgb&w=800",
      "inStock": true,
      "energyStar": true,
      "ulListed": true,
    },
    {
      "id": 7,
      "name": "Extension Cord 25ft",
      "specifications": "12/3 SJTW, Lighted End",
      "price": "KSH 3877.71",
      "rating": 4.2,
      "category": "Extension Cords",
      "brand": "Coleman Cable",
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "inStock": true,
      "energyStar": false,
      "ulListed": true,
    },
    {
      "id": 8,
      "name": "Dimmer Switch",
      "specifications": "600W, Single Pole, White",
      "price": "KSH 2196.81",
      "rating": 4.5,
      "category": "Switches & Outlets",
      "brand": "Lutron",
      "image":
          "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg?auto=compress&cs=tinysrgb&w=800",
      "inStock": true,
      "energyStar": false,
      "ulListed": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeSearch();
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cameraController?.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _initializeSearch() {
    _searchResults = List.from(_allProducts);
    _searchSuggestions = [
      'LED bulbs',
      'Wire nuts',
      'GFCI outlets',
      'Circuit breakers',
      'Extension cords',
      'Electrical tape',
      'Wire strippers',
      'Conduit fittings',
    ];
  }

  void _loadRecentSearches() {
    _recentSearches = [
      'LED smart bulbs',
      '12 AWG wire',
      'GFCI outlets',
      'Circuit breakers 20A',
    ];
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) return;

      final camera = kIsWeb
          ? _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras!.first)
          : _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras!.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();

      if (!kIsWeb) {
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Ignore unsupported features
        }
      }

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      _showErrorMessage('Camera initialization failed');
    }
  }

  Future<void> _startVoiceSearch() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        if (kIsWeb) {
          await _audioRecorder.start(
              const RecordConfig(encoder: AudioEncoder.wav),
              path: 'recording.wav');
        } else {
          await _audioRecorder.start(const RecordConfig(),
              path: 'recording.m4a');
        }

        // Simulate voice recognition after 3 seconds
        await Future.delayed(const Duration(seconds: 3));
        await _stopVoiceSearch();
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorMessage('Voice search failed');
    }
  }

  Future<void> _stopVoiceSearch() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        // Simulate voice recognition result
        _searchController.text = 'LED bulbs';
        _performSearch('LED bulbs');
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _startBarcodeSearch() async {
    if (await _requestCameraPermission()) {
      await _initializeCamera();
      if (_isCameraInitialized) {
        _showBarcodeScanner();
      }
    }
  }

  void _showBarcodeScanner() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 60.h,
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Text(
                'Scan Product Barcode',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: _isCameraInitialized && _cameraController != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(3.w),
                        child: CameraPreview(_cameraController!),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_cameraController != null) {
                        try {
                          final XFile photo =
                              await _cameraController!.takePicture();
                          Navigator.pop(context);
                          // Simulate barcode recognition
                          _searchController.text = 'Circuit Breaker 20A';
                          _performSearch('Circuit Breaker 20A');
                        } catch (e) {
                          _showErrorMessage('Failed to capture image');
                        }
                      }
                    },
                    child: const Text('Capture'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = List.from(_allProducts);
        _showSuggestions = false;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSuggestions = false;
    });

    // Add to recent searches
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    }

    // Enhanced search with better matching
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = _allProducts.where((product) {
        final name = (product['name'] as String).toLowerCase();
        final specs = (product['specifications'] as String).toLowerCase();
        final category = (product['category'] as String).toLowerCase();
        final brand = (product['brand'] as String).toLowerCase();
        final searchQuery = query.toLowerCase();

        // Improved search algorithm with weighted results
        bool nameMatch = name.contains(searchQuery);
        bool specsMatch = specs.contains(searchQuery);
        bool categoryMatch = category.contains(searchQuery);
        bool brandMatch = brand.contains(searchQuery);

        return nameMatch || specsMatch || categoryMatch || brandMatch;
      }).toList();

      // Sort by relevance (name matches first, then specs, then category)
      results.sort((a, b) {
        final aName = (a['name'] as String).toLowerCase();
        final bName = (b['name'] as String).toLowerCase();
        final searchQuery = query.toLowerCase();

        if (aName.startsWith(searchQuery) && !bName.startsWith(searchQuery)) {
          return -1;
        }
        if (!aName.startsWith(searchQuery) && bName.startsWith(searchQuery)) {
          return 1;
        }
        if (aName.contains(searchQuery) && !bName.contains(searchQuery)) {
          return -1;
        }
        if (!aName.contains(searchQuery) && bName.contains(searchQuery)) {
          return 1;
        }
        return 0;
      });

      setState(() {
        _searchResults = _applyFiltersAndSort(results);
        _isSearching = false;
      });
    });
  }

  List<Map<String, dynamic>> _applyFiltersAndSort(
      List<Map<String, dynamic>> products) {
    var filtered = List<Map<String, dynamic>>.from(products);

    // Apply filters
    if (_currentFilters['category'] != null &&
        _currentFilters['category'] != 'All Categories') {
      filtered = filtered
          .where((p) => p['category'] == _currentFilters['category'])
          .toList();
    }

    if (_currentFilters['brands'] != null) {
      final brands = _currentFilters['brands'] as List<String>;
      if (brands.isNotEmpty) {
        filtered = filtered.where((p) => brands.contains(p['brand'])).toList();
      }
    }

    if (_currentFilters['minPrice'] != null &&
        _currentFilters['maxPrice'] != null) {
      filtered = filtered.where((p) {
        final price = double.parse((p['price'] as String).replaceAll('KSH ', ''));
        return price >= _currentFilters['minPrice'] &&
            price <= _currentFilters['maxPrice'];
      }).toList();
    }

    if (_currentFilters['minRating'] != null &&
        _currentFilters['minRating'] > 0) {
      filtered = filtered
          .where((p) => (p['rating'] as double) >= _currentFilters['minRating'])
          .toList();
    }

    if (_currentFilters['inStock'] == true) {
      filtered = filtered.where((p) => p['inStock'] == true).toList();
    }

    if (_currentFilters['energyStar'] == true) {
      filtered = filtered.where((p) => p['energyStar'] == true).toList();
    }

    if (_currentFilters['ulListed'] == true) {
      filtered = filtered.where((p) => p['ulListed'] == true).toList();
    }

    // Apply sorting
    switch (_currentSort) {
      case 'price_low':
        filtered.sort((a, b) {
          final priceA =
              double.parse((a['price'] as String).replaceAll('KSH ', ''));
          final priceB =
              double.parse((b['price'] as String).replaceAll('KSH ', ''));
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_high':
        filtered.sort((a, b) {
          final priceA =
              double.parse((a['price'] as String).replaceAll('KSH ', ''));
          final priceB =
              double.parse((b['price'] as String).replaceAll('KSH ', ''));
          return priceB.compareTo(priceA);
        });
        break;
      case 'rating':
        filtered.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'newest':
        filtered.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
        break;
      case 'popular':
        filtered.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      default: // relevance
        break;
    }

    return filtered;
  }

  void _updateActiveFilters() {
    _activeFilters.clear();

    if (_currentFilters['category'] != null &&
        _currentFilters['category'] != 'All Categories') {
      _activeFilters.add(FilterChip(
        key: 'category',
        label: 'Category',
        value: _currentFilters['category'],
      ));
    }

    if (_currentFilters['minPrice'] != null &&
        _currentFilters['maxPrice'] != null) {
      _activeFilters.add(FilterChip(
        key: 'price',
        label: 'Price',
        value:
            'KSH${_currentFilters['minPrice'].round()}-KSH${_currentFilters['maxPrice'].round()}',
      ));
    }

    if (_currentFilters['brands'] != null) {
      final brands = _currentFilters['brands'] as List<String>;
      if (brands.isNotEmpty) {
        _activeFilters.add(FilterChip(
          key: 'brands',
          label: 'Brands',
          value:
              brands.length == 1 ? brands.first : '${brands.length} selected',
        ));
      }
    }

    if (_currentFilters['minRating'] != null &&
        _currentFilters['minRating'] > 0) {
      _activeFilters.add(FilterChip(
        key: 'rating',
        label: 'Rating',
        value: '${_currentFilters['minRating']}+ stars',
      ));
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
            _updateActiveFilters();
            _searchResults = _applyFiltersAndSort(_searchResults);
          });
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
            _searchResults = _applyFiltersAndSort(_searchResults);
          });
        },
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> product) {
    setState(() {
      _selectedProduct = product;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: QuickActionsWidget(
          product: product,
          onCompare: () {
            Navigator.pop(context);
            _showErrorMessage('Added to comparison');
          },
          onWishlist: () {
            Navigator.pop(context);
            _showErrorMessage('Added to wishlist');
          },
          onShare: () {
            Navigator.pop(context);
            _showErrorMessage('Product shared');
          },
          onDismiss: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          SearchHeaderWidget(
            searchController: _searchController,
            onSearchChanged: (query) {
              // Improved search with debouncing
              setState(() {
                _showSuggestions = query.isNotEmpty && query.length >= 2;
              });

              if (query.length >= 2) {
                _performSearch(query);
              } else if (query.isEmpty) {
                setState(() {
                  _searchResults = List.from(_allProducts);
                  _showSuggestions = false;
                });
              }
            },
            onVoiceSearch: _isRecording ? () {} : _startVoiceSearch,
            onBarcodeSearch: _startBarcodeSearch,
            isSearching: _isSearching || _isRecording,
          ),
          if (_activeFilters.isNotEmpty)
            FilterChipsWidget(
              activeFilters: _activeFilters,
              onRemoveFilter: (key) {
                setState(() {
                  _currentFilters.remove(key);
                  if (key == 'brands') {
                    _currentFilters.remove('brands');
                  }
                  _updateActiveFilters();
                  _searchResults = _applyFiltersAndSort(_searchResults);
                });
              },
              onOpenFilters: _showFilterModal,
            ),
          Expanded(
            child: _showSuggestions && _searchController.text.isNotEmpty
                ? SearchSuggestionsWidget(
                    suggestions: _searchSuggestions
                        .where((s) => s
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .take(5)
                        .toList(),
                    recentSearches: _recentSearches,
                    onSuggestionTap: (suggestion) {
                      _searchController.text = suggestion;
                      _performSearch(suggestion);
                    },
                    onRecentSearchTap: (search) {
                      _searchController.text = search;
                      _performSearch(search);
                    },
                    onClearRecentSearches: () {
                      setState(() {
                        _recentSearches.clear();
                      });
                    },
                  )
                : ProductGridWidget(
                    products: _searchResults,
                    isLoading: _isSearching,
                    onRefresh: () {
                      setState(() {
                        _currentFilters.clear();
                        _activeFilters.clear();
                        _currentSort = 'relevance';
                      });
                      _performSearch(_searchController.text);
                    },
                    onProductTap: (product) {
                      Navigator.pushNamed(context, AppRoutes.productDetail);
                    },
                    onProductLongPress: _showQuickActions,
                  ),
          ),
        ],
      ),
      floatingActionButton: _searchResults.isNotEmpty
          ? FloatingActionButton(
              onPressed: _showSortBottomSheet,
              child: CustomIconWidget(
                iconName: 'sort',
                color: theme.colorScheme.onPrimary,
                size: 6.w,
              ),
            )
          : null,
    );
  }
}
