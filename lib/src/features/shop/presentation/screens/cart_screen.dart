import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_shadows.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';

/// Cart screen
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<_CartItem> _cartItems = [
    _CartItem(
      id: '1',
      name: 'Custom Tailored Suit',
      description: 'Navy Blue, Wool',
      price: 250.00,
      quantity: 1,
      icon: Icons.business_center,
    ),
    _CartItem(
      id: '2',
      name: 'White Dress Shirt',
      description: 'Cotton, Slim Fit',
      price: 45.00,
      quantity: 2,
      icon: Icons.dry_cleaning,
    ),
  ];

  double get _subtotal => _cartItems.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

  double get _tailoringFee => 20.00;
  double get _deliveryFee => 10.00;
  double get _total => _subtotal + _tailoringFee + _deliveryFee;

  void _updateQuantity(_CartItem item, int delta) {
    setState(() {
      final index = _cartItems.indexOf(item);
      if (index != -1) {
        final newQuantity = item.quantity + delta;
        if (newQuantity > 0) {
          _cartItems[index] = item.copyWith(quantity: newQuantity);
        } else {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  void _removeItem(_CartItem item) {
    setState(() {
      _cartItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart'),
        automaticallyImplyLeading: false,
        actions: [
          if (_cartItems.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _cartItems.clear()),
              child: Text(
                'Clear All',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: _cartItems.isEmpty
          ? _EmptyCart()
          : Column(
              children: [
                // Cart items list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _CartItemCard(
                        item: item,
                        onIncrement: () => _updateQuantity(item, 1),
                        onDecrement: () => _updateQuantity(item, -1),
                        onRemove: () => _removeItem(item),
                      )
                          .animate(delay: Duration(milliseconds: index * 100))
                          .fadeIn()
                          .slideX(begin: -0.05, end: 0);
                    },
                  ),
                ),

                // Order summary
                Container(
                  padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        _SummaryRow(label: 'Subtotal', value: _subtotal),
                        _SummaryRow(label: 'Tailoring Fee', value: _tailoringFee),
                        _SummaryRow(label: 'Delivery', value: _deliveryFee),
                        const Divider(),
                        _SummaryRow(
                          label: 'Total',
                          value: _total,
                          isTotal: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppButton.gradient(
                          text: 'Proceed to Checkout',
                          onPressed: () {
                            // TODO: Checkout
                            context.push(AppRoutes.createOrder);
                          },
                          trailingIcon: Icons.arrow_forward,
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),
              ],
            ),
    );
  }
}

class _CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final IconData icon;

  _CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.icon,
  });

  _CartItem copyWith({int? quantity}) {
    return _CartItem(
      id: id,
      name: name,
      description: description,
      price: price,
      quantity: quantity ?? this.quantity,
      icon: icon,
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final _CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.paddingLg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.border.withValues(alpha: 0.3),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(
                item.icon,
                color: AppColors.textTertiary,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTypography.titleSmall),
                  Text(
                    item.description,
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTypography.price.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            // Quantity controls
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: onDecrement,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(
                        width: 28,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: AppTypography.titleSmall,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: onIncrement,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTypography.titleMedium
                : AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: isTotal ? AppTypography.price : AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 56,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Your Cart is Empty',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Browse our categories and find\nyour perfect tailored outfit',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton.primary(
            text: 'Start Shopping',
            onPressed: () => context.go(AppRoutes.category),
            leadingIcon: Icons.shopping_bag_outlined,
          ),
        ],
      ).animate().fadeIn().scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
          ),
    );
  }
}

