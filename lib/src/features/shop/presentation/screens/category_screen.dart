import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/constants/app_constants.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_shadows.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';

/// Category screen (Shop tab)
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  GarmentType? _selectedCategory;
  String _selectedFilter = 'All';

  final List<_Product> _products = [
    _Product(
      name: 'Classic White Shirt',
      price: 45.00,
      rating: 4.8,
      reviews: 124,
      type: GarmentType.shirt,
      icon: Icons.dry_cleaning,
    ),
    _Product(
      name: 'Navy Business Suit',
      price: 320.00,
      rating: 4.9,
      reviews: 89,
      type: GarmentType.suit,
      icon: Icons.business_center,
    ),
    _Product(
      name: 'Slim Fit Trousers',
      price: 65.00,
      rating: 4.7,
      reviews: 156,
      type: GarmentType.pants,
      icon: Icons.accessibility_new,
    ),
    _Product(
      name: 'Traditional Thobe',
      price: 120.00,
      rating: 4.9,
      reviews: 234,
      type: GarmentType.thobe,
      icon: Icons.person,
    ),
    _Product(
      name: 'Elegant Blazer',
      price: 180.00,
      rating: 4.6,
      reviews: 67,
      type: GarmentType.jacket,
      icon: Icons.style,
    ),
    _Product(
      name: 'Wedding Dress',
      price: 550.00,
      rating: 5.0,
      reviews: 45,
      type: GarmentType.dress,
      icon: Icons.checkroom,
    ),
  ];

  List<_Product> get _filteredProducts {
    if (_selectedCategory == null) return _products;
    return _products.where((p) => p.type == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Categories', style: AppTypography.headlineMedium),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ).animate().fadeIn(),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingHorizontal,
                  ),
                  itemCount: GarmentType.values.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _CategoryChip(
                        label: 'All',
                        icon: Icons.apps,
                        isSelected: _selectedCategory == null,
                        onTap: () => setState(() => _selectedCategory = null),
                      ).animate(delay: Duration(milliseconds: index * 50)).fadeIn();
                    }
                    final type = GarmentType.values[index - 1];
                    return _CategoryChip(
                      label: type.displayName,
                      icon: _getCategoryIcon(type),
                      isSelected: _selectedCategory == type,
                      onTap: () => setState(() => _selectedCategory = type),
                    ).animate(delay: Duration(milliseconds: index * 50)).fadeIn();
                  },
                ),
              ),
            ),

            // Filters row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
                child: Row(
                  children: [
                    Text(
                      '${_filteredProducts.length} Items',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    // Sort dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.paddingSm,
                        vertical: AppSpacing.paddingXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppSpacing.borderRadiusSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        items: ['All', 'Price: Low', 'Price: High', 'Rating']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedFilter = value ?? 'All');
                        },
                        underline: const SizedBox.shrink(),
                        isDense: true,
                        style: AppTypography.labelMedium,
                      ),
                    ),
                  ],
                ).animate(delay: 300.ms).fadeIn(),
              ),
            ),

            // Products grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = _filteredProducts[index];
                    return _ProductCard(
                      product: product,
                      onTap: () => context.push(AppRoutes.createOrder),
                    )
                        .animate(delay: Duration(milliseconds: 400 + (index * 100)))
                        .fadeIn()
                        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
                  },
                  childCount: _filteredProducts.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(GarmentType type) {
    switch (type) {
      case GarmentType.shirt:
        return Icons.dry_cleaning;
      case GarmentType.pants:
        return Icons.accessibility_new;
      case GarmentType.suit:
        return Icons.business_center;
      case GarmentType.dress:
        return Icons.checkroom;
      case GarmentType.jacket:
        return Icons.style;
      case GarmentType.thobe:
        return Icons.person;
      case GarmentType.abaya:
        return Icons.woman;
      case GarmentType.other:
        return Icons.category;
    }
  }
}

class _Product {
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final GarmentType type;
  final IconData icon;

  _Product({
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.type,
    required this.icon,
  });
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surface,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: isSelected ? AppShadows.sm : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusLg,
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.border.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSpacing.radiusLg),
                      ),
                    ),
                    child: Icon(
                      product.icon,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  // Wishlist button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.sm,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.paddingSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' (${product.reviews})',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.price.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

