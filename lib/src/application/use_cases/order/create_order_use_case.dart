import 'package:tailorhouse/src/application/common/use_case.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Input for creating a new order
class CreateOrderInput {
  final String customerId;
  final String customerName;
  final String customerPhone;
  final GarmentType garmentType;
  final String fabricDescription;
  final String? fabricColor;
  final double totalPrice;
  final double depositPaid;
  final DateTime expectedDeliveryDate;
  final String? notes;

  /// User creating the order
  final String createdByUserId;
  final String createdByUserName;
  final String createdByUserRole;

  const CreateOrderInput({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.garmentType,
    required this.fabricDescription,
    this.fabricColor,
    required this.totalPrice,
    required this.depositPaid,
    required this.expectedDeliveryDate,
    this.notes,
    required this.createdByUserId,
    required this.createdByUserName,
    required this.createdByUserRole,
  });
}

/// Output after creating an order
class CreateOrderOutput {
  final Order order;
  final String garmentIdDisplay;

  const CreateOrderOutput({
    required this.order,
    required this.garmentIdDisplay,
  });
}

/// Use case for creating a new order
/// 
/// Business Flow:
/// 1. Get current shop
/// 2. Generate next garment ID
/// 3. Create order entity
/// 4. Persist order
/// 5. Return created order with garment ID
class CreateOrderUseCase implements UseCase<CreateOrderInput, Result<CreateOrderOutput>> {
  final OrderRepository _orderRepository;
  final ShopRepository _shopRepository;

  CreateOrderUseCase({
    required OrderRepository orderRepository,
    required ShopRepository shopRepository,
  })  : _orderRepository = orderRepository,
        _shopRepository = shopRepository;

  @override
  Future<Result<CreateOrderOutput>> execute(CreateOrderInput input) async {
    try {
      // 1. Get current shop
      final shop = await _shopRepository.getCurrentShop();
      if (shop == null) {
        return Result.failure(NotFoundFailure(
          entityType: 'Shop',
          entityId: 'current',
        ));
      }

      // 2. Validate input
      final validationError = _validateInput(input);
      if (validationError != null) {
        return Result.failure(validationError);
      }

      // 3. Generate garment ID
      final currentYear = DateTime.now().year % 100; // Two-digit year
      final lastSequence = await _orderRepository.getLastGarmentSequence(
        shop.code,
        currentYear,
      );

      final garmentIdGenerator = GarmentIdGenerator(shopCode: shop.code);
      final garmentId = garmentIdGenerator.generateNext(
        currentYear: currentYear,
        lastSequence: lastSequence,
      );

      // 4. Create order entity
      final orderId = _generateOrderId();
      final order = Order.create(
        id: orderId,
        garmentId: garmentId,
        shopId: shop.id,
        customerId: input.customerId,
        customerName: input.customerName,
        customerPhone: input.customerPhone,
        garmentType: input.garmentType,
        fabricDescription: input.fabricDescription,
        fabricColor: input.fabricColor,
        totalPrice: Money.fromAmount(input.totalPrice, currency: shop.currency),
        depositPaid: Money.fromAmount(input.depositPaid, currency: shop.currency),
        expectedDeliveryDate: input.expectedDeliveryDate,
        notes: input.notes,
        createdBy: input.createdByUserId,
        createdByName: input.createdByUserName,
        createdByRole: input.createdByUserRole,
      );

      // 5. Persist order
      final savedOrder = await _orderRepository.create(order);

      // 6. Increment sequence for next use
      await _orderRepository.getNextGarmentSequence(shop.code, currentYear);

      return Result.success(CreateOrderOutput(
        order: savedOrder,
        garmentIdDisplay: garmentId.toString(),
      ));
    } on DomainException catch (e) {
      return Result.failure(Failure(
        message: e.message,
        arabicMessage: e.arabicMessage,
        originalError: e,
      ));
    } catch (e) {
      return Result.failure(StorageFailure(
        message: 'Failed to create order: $e',
        arabicMessage: 'فشل في إنشاء الطلب',
      ));
    }
  }

  ValidationFailure? _validateInput(CreateOrderInput input) {
    if (input.customerName.trim().isEmpty) {
      return ValidationFailure(
        message: 'Customer name is required',
        arabicMessage: 'اسم الزبون مطلوب',
        field: 'customerName',
      );
    }

    if (input.customerPhone.trim().isEmpty) {
      return ValidationFailure(
        message: 'Customer phone is required',
        arabicMessage: 'رقم هاتف الزبون مطلوب',
        field: 'customerPhone',
      );
    }

    if (input.fabricDescription.trim().isEmpty) {
      return ValidationFailure(
        message: 'Fabric description is required',
        arabicMessage: 'وصف القماش مطلوب',
        field: 'fabricDescription',
      );
    }

    if (input.totalPrice <= 0) {
      return ValidationFailure(
        message: 'Total price must be positive',
        arabicMessage: 'السعر الإجمالي يجب أن يكون أكبر من صفر',
        field: 'totalPrice',
      );
    }

    if (input.depositPaid < 0) {
      return ValidationFailure(
        message: 'Deposit cannot be negative',
        arabicMessage: 'العربون لا يمكن أن يكون سالباً',
        field: 'depositPaid',
      );
    }

    if (input.depositPaid > input.totalPrice) {
      return ValidationFailure(
        message: 'Deposit cannot exceed total price',
        arabicMessage: 'العربون لا يمكن أن يتجاوز السعر الإجمالي',
        field: 'depositPaid',
      );
    }

    if (input.expectedDeliveryDate.isBefore(DateTime.now())) {
      return ValidationFailure(
        message: 'Expected delivery date must be in the future',
        arabicMessage: 'تاريخ التسليم المتوقع يجب أن يكون في المستقبل',
        field: 'expectedDeliveryDate',
      );
    }

    return null;
  }

  String _generateOrderId() {
    // Generate a unique ID (in real implementation, use UUID)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD_$timestamp';
  }
}

