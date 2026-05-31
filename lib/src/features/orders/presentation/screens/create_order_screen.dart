import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';
import 'package:tailorhouse/src/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailorhouse/src/features/customer/presentation/bloc/customer_bloc.dart';
import 'package:tailorhouse/src/domain/domain.dart';
import 'package:intl/intl.dart';

/// Create Order Screen
/// 
/// Per PRD FR-1: Create orders with customer name, phone, garment type,
/// fabric type, total price, deposit, expected delivery date
class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _fabricDescriptionController = TextEditingController();
  final _fabricColorController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _depositController = TextEditingController();
  final _notesController = TextEditingController();

  GarmentType _selectedGarmentType = GarmentType.thobe;
  DateTime _selectedDeliveryDate = DateTime.now().add(const Duration(days: 7));
  final String _currentShopId = 'SHOP_001'; // TODO: Get from current user
  final String _currentUserId = 'USER_001'; // TODO: Get from current user
  final String _currentUserName = 'موظف'; // TODO: Get from current user
  final String _currentUserRole = 'staff'; // TODO: Get from current user

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _fabricDescriptionController.dispose();
    _fabricColorController.dispose();
    _totalPriceController.dispose();
    _depositController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDeliveryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() => _selectedDeliveryDate = picked);
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final totalPrice = double.tryParse(_totalPriceController.text) ?? 0;
    final deposit = double.tryParse(_depositController.text) ?? 0;

    if (deposit > totalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('العربون لا يمكن أن يتجاوز السعر الإجمالي')),
      );
      return;
    }

    // First, get or create customer
    context.read<CustomerBloc>().add(
          GetOrCreateCustomerEvent(
            shopId: _currentShopId,
            name: _customerNameController.text.trim(),
            phone: _customerPhoneController.text.trim(),
          ),
        );
  }

  void _createOrderWithCustomer(Customer customer) {
    final totalPrice = double.tryParse(_totalPriceController.text) ?? 0;
    final deposit = double.tryParse(_depositController.text) ?? 0;

    context.read<OrderBloc>().add(
          CreateOrderEvent(
            customerId: customer.id,
            customerName: customer.name,
            customerPhone: customer.phoneNumber.international,
            garmentType: _selectedGarmentType,
            fabricDescription: _fabricDescriptionController.text.trim(),
            fabricColor: _fabricColorController.text.trim().isEmpty
                ? null
                : _fabricColorController.text.trim(),
            totalPrice: Money.fromAmount(totalPrice),
            depositPaid: Money.fromAmount(deposit),
            expectedDeliveryDate: _selectedDeliveryDate,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            createdBy: _currentUserId,
            createdByName: _currentUserName,
            createdByRole: _currentUserRole,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء طلب جديد', style: AppTypography.titleLarge),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is CustomerLoaded) {
                _createOrderWithCustomer(state.customer);
              } else if (state is CustomerError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إنشاء الطلب: ${state.order.garmentId}'),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.pop();
              } else if (state is OrderError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            final isLoading = state is OrderLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Customer Section
                  _SectionHeader(title: 'معلومات الزبون'),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: 'اسم الزبون',
                    hint: 'أدخل اسم الزبون',
                    controller: _customerNameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'اسم الزبون مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'رقم الهاتف',
                    hint: 'أدخل رقم الهاتف',
                    controller: _customerPhoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'رقم الهاتف مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Order Details Section
                  _SectionHeader(title: 'تفاصيل الطلب'),
                  const SizedBox(height: AppSpacing.sm),
                  // Garment Type
                  DropdownButtonFormField<GarmentType>(
                    value: _selectedGarmentType,
                    decoration: const InputDecoration(
                      labelText: 'نوع القطعة',
                      border: OutlineInputBorder(),
                    ),
                    items: GarmentType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.arabicName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedGarmentType = value);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'وصف القماش',
                    hint: 'مثال: قماش صوفي، قماش قطني...',
                    controller: _fabricDescriptionController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'وصف القماش مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'لون القماش (اختياري)',
                    hint: 'مثال: أسود، أزرق...',
                    controller: _fabricColorController,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Pricing Section
                  _SectionHeader(title: 'التسعير'),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: 'السعر الإجمالي',
                    hint: '0.00',
                    controller: _totalPriceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'السعر الإجمالي مطلوب';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'السعر يجب أن يكون أكبر من صفر';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'العربون المدفوع',
                    hint: '0.00',
                    controller: _depositController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'العربون مطلوب';
                      }
                      final deposit = double.tryParse(value);
                      if (deposit == null || deposit < 0) {
                        return 'العربون يجب أن يكون أكبر من أو يساوي صفر';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Delivery Date
                  _SectionHeader(title: 'تاريخ التسليم'),
                  const SizedBox(height: AppSpacing.sm),
                  InkWell(
                    onTap: _selectDeliveryDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'تاريخ التسليم المتوقع',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('yyyy/MM/dd', 'ar').format(_selectedDeliveryDate),
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Notes
                  AppTextField.multiline(
                    label: 'ملاحظات (اختياري)',
                    hint: 'أي ملاحظات إضافية...',
                    controller: _notesController,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Submit Button
                  AppButton.primary(
                    text: 'إنشاء الطلب',
                    onPressed: isLoading ? null : _onSubmit,
                    isLoading: isLoading,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}
