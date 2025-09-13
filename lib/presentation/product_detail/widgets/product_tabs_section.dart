import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductTabsSection extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductTabsSection({
    super.key,
    required this.product,
  });

  @override
  State<ProductTabsSection> createState() => _ProductTabsSectionState();
}

class _ProductTabsSectionState extends State<ProductTabsSection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Tab bar
        Container(
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
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            labelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 2,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Technical Specs'),
              Tab(text: 'Reviews'),
              Tab(text: 'Installation Guide'),
            ],
          ),
        ),

        // Tab content
        Container(
          height: 60.h,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(context),
              _buildTechnicalSpecsTab(context),
              _buildReviewsTab(context),
              _buildInstallationGuideTab(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final theme = Theme.of(context);
    final keySpecs = widget.product['keySpecs'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'Description',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            widget.product['description'] as String? ??
                'No description available.',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
          ),

          SizedBox(height: 3.h),

          // Key specifications
          if (keySpecs.isNotEmpty) ...[
            Text(
              'Key Specifications',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...keySpecs.map((spec) {
              final specMap = spec as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        specMap['label'] as String? ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        specMap['value'] as String? ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildTechnicalSpecsTab(BuildContext context) {
    final theme = Theme.of(context);
    final technicalSpecs =
        widget.product['technicalSpecs'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Technical Specifications',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _copySpecsToClipboard(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'copy_all',
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Copy',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (technicalSpecs.isEmpty)
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  CustomIconWidget(
                    iconName: 'description',
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No technical specifications available',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          else
            ...technicalSpecs.map((spec) {
              final specMap = spec as Map<String, dynamic>;
              return GestureDetector(
                onLongPress: () => _copySpecToClipboard(context, specMap),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          specMap['label'] as String? ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          specMap['value'] as String? ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(BuildContext context) {
    final theme = Theme.of(context);
    final reviews = widget.product['reviews'] as List<dynamic>? ?? [];
    final rating = (widget.product['rating'] as num?)?.toDouble() ?? 0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return CustomIconWidget(
                          iconName:
                              index < rating.floor() ? 'star' : 'star_border',
                          size: 20,
                          color: index < rating.floor()
                              ? AppTheme.getWarningColor(
                                  theme.brightness == Brightness.light)
                              : theme.colorScheme.onSurfaceVariant,
                        );
                      }),
                    ),
                    Text(
                      '${reviews.length} reviews',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      final starCount = 5 - index;
                      final count = reviews
                          .where((review) =>
                              ((review as Map<String, dynamic>)['rating']
                                      as num)
                                  .toInt() ==
                              starCount)
                          .length;
                      final percentage =
                          reviews.isNotEmpty ? (count / reviews.length) : 0.0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Text(
                              '$starCount',
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(width: 4),
                            CustomIconWidget(
                              iconName: 'star',
                              size: 12,
                              color: AppTheme.getWarningColor(
                                  theme.brightness == Brightness.light),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: theme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$count',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Reviews list
          if (reviews.isEmpty)
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  CustomIconWidget(
                    iconName: 'rate_review',
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No reviews yet',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Be the first to review this product',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          else
            ...reviews.map((review) {
              final reviewMap = review as Map<String, dynamic>;
              final reviewRating =
                  (reviewMap['rating'] as num?)?.toDouble() ?? 0.0;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            (reviewMap['userName'] as String? ?? 'U')[0]
                                .toUpperCase(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviewMap['userName'] as String? ?? 'Anonymous',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return CustomIconWidget(
                                        iconName: index < reviewRating.floor()
                                            ? 'star'
                                            : 'star_border',
                                        size: 16,
                                        color: index < reviewRating.floor()
                                            ? AppTheme.getWarningColor(
                                                theme.brightness ==
                                                    Brightness.light)
                                            : theme
                                                .colorScheme.onSurfaceVariant,
                                      );
                                    }),
                                  ),
                                  SizedBox(width: 2.w),
                                  if (reviewMap['verified'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.getSuccessColor(
                                            theme.brightness ==
                                                Brightness.light),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Verified',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          reviewMap['date'] as String? ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      reviewMap['comment'] as String? ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildInstallationGuideTab(BuildContext context) {
    final theme = Theme.of(context);
    final hasGuide = widget.product['installationGuide'] != null;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Installation Guide',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          if (!hasGuide)
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  CustomIconWidget(
                    iconName: 'description',
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No installation guide available',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'picture_as_pdf',
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Installation Guide PDF',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Step-by-step installation instructions with diagrams',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _viewInstallationGuide(context),
                          icon: CustomIconWidget(
                            iconName: 'visibility',
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Text('View Guide'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _downloadInstallationGuide(context),
                          icon: CustomIconWidget(
                            iconName: 'download',
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          label: const Text('Download'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Safety warnings
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getWarningColor(
                        theme.brightness == Brightness.light)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.getWarningColor(
                          theme.brightness == Brightness.light)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        size: 20,
                        color: AppTheme.getWarningColor(
                            theme.brightness == Brightness.light),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Safety Warning',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Always turn off power at the circuit breaker before installation. If you\'re not comfortable with electrical work, consult a licensed electrician.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _copySpecsToClipboard(BuildContext context) {
    final technicalSpecs =
        widget.product['technicalSpecs'] as List<dynamic>? ?? [];
    final specsText = technicalSpecs.map((spec) {
      final specMap = spec as Map<String, dynamic>;
      return '${specMap['label']}: ${specMap['value']}';
    }).join('\n');

    Clipboard.setData(ClipboardData(text: specsText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Technical specifications copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copySpecToClipboard(BuildContext context, Map<String, dynamic> spec) {
    final specText = '${spec['label']}: ${spec['value']}';
    Clipboard.setData(ClipboardData(text: specText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${spec['label']} copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewInstallationGuide(BuildContext context) {
    // TODO: Implement PDF viewer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening installation guide...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _downloadInstallationGuide(BuildContext context) {
    // TODO: Implement PDF download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading installation guide...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
