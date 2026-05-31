import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';
import 'package:tailorhouse/src/features/customer/presentation/bloc/customer_bloc.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Customer Search Screen
/// 
/// Allows searching for existing customers or creating new ones
class CustomerSearchScreen extends StatefulWidget {
  final Function(Customer)? onCustomerSelected;

  const CustomerSearchScreen({
    super.key,
    this.onCustomerSelected,
  });

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _currentShopId = 'SHOP_001'; // TODO: Get from current user

  @override
  void initState() {
    super.initState();
    // Load all customers initially
    context.read<CustomerBloc>().add(
          GetAllCustomersEvent(shopId: _currentShopId),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      context.read<CustomerBloc>().add(
            GetAllCustomersEvent(shopId: _currentShopId),
          );
    } else {
      context.read<CustomerBloc>().add(
            SearchCustomersEvent(
              shopId: _currentShopId,
              query: query,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن زبون', style: AppTypography.titleLarge),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppTextField(
              label: 'ابحث بالاسم أو رقم الهاتف',
              hint: 'أدخل اسم الزبون أو رقم الهاتف...',
              controller: _searchController,
              onChanged: _onSearch,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          // Customers list
          Expanded(
            child: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is CustomerLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CustomerError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: AppColors.error),
                        const SizedBox(height: AppSpacing.md),
                        Text(state.message, style: AppTypography.bodyLarge),
                      ],
                    ),
                  );
                }

                if (state is CustomersLoaded) {
                  if (state.customers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search, size: 64, color: AppColors.textSecondary),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'لا توجد نتائج',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.customers.length,
                    itemBuilder: (context, index) {
                      final customer = state.customers[index];
                      return _CustomerCard(
                        customer: customer,
                        onTap: () {
                          if (widget.onCustomerSelected != null) {
                            widget.onCustomerSelected!(customer);
                            context.pop();
                          }
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  customer.name[0].toUpperCase(),
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          customer.formattedPhone,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

