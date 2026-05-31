import 'package:tailorhouse/src/application/common/use_case.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Input for customer viewing their order
class CustomerViewOrderInput {
  /// Garment ID to look up (e.g., "TF01-25-00001")
  final String garmentId;
  
  /// Customer phone for verification
  final String customerPhone;

  const CustomerViewOrderInput({
    required this.garmentId,
    required this.customerPhone,
  });
}

/// Simplified order info for customer view
class CustomerOrderView {
  final String garmentIdDisplay;
  final GarmentType garmentType;
  final String garmentTypeArabic;
  final GarmentStatus status;
  final String statusArabic;
  final DateTime expectedDeliveryDate;
  final bool isReady;
  final bool isDelivered;
  final double progressPercentage;
  final List<CustomerWorkflowStage> stages;
  final String shopName;
  final String shopPhone;

  const CustomerOrderView({
    required this.garmentIdDisplay,
    required this.garmentType,
    required this.garmentTypeArabic,
    required this.status,
    required this.statusArabic,
    required this.expectedDeliveryDate,
    required this.isReady,
    required this.isDelivered,
    required this.progressPercentage,
    required this.stages,
    required this.shopName,
    required this.shopPhone,
  });
}

/// Simplified workflow stage for customer view
class CustomerWorkflowStage {
  final String nameArabic;
  final String nameEnglish;
  final bool isCompleted;
  final bool isCurrent;
  final int stageNumber;

  const CustomerWorkflowStage({
    required this.nameArabic,
    required this.nameEnglish,
    required this.isCompleted,
    required this.isCurrent,
    required this.stageNumber,
  });
}

/// Use case for customer viewing their order status
/// 
/// Security:
/// - Requires phone number verification
/// - Returns limited information (no prices, no internal details)
/// - Only shows relevant workflow stages
class CustomerViewOrderUseCase implements UseCase<CustomerViewOrderInput, Result<CustomerOrderView>> {
  final OrderRepository _orderRepository;
  final ShopRepository _shopRepository;
  final WorkflowStateMachine _workflowStateMachine;

  CustomerViewOrderUseCase({
    required OrderRepository orderRepository,
    required ShopRepository shopRepository,
    WorkflowStateMachine? workflowStateMachine,
  })  : _orderRepository = orderRepository,
        _shopRepository = shopRepository,
        _workflowStateMachine = workflowStateMachine ?? const WorkflowStateMachine();

  @override
  Future<Result<CustomerOrderView>> execute(CustomerViewOrderInput input) async {
    try {
      // 1. Get order by garment ID
      final order = await _orderRepository.getByGarmentId(input.garmentId);
      if (order == null) {
        return Result.failure(NotFoundFailure(
          entityType: 'Order',
          entityId: input.garmentId,
        ));
      }

      // 2. Verify customer phone matches
      final normalizedInputPhone = _normalizePhone(input.customerPhone);
      final normalizedOrderPhone = _normalizePhone(order.customerPhone);
      
      if (normalizedInputPhone != normalizedOrderPhone) {
        // Return generic "not found" to prevent information disclosure
        return Result.failure(NotFoundFailure(
          entityType: 'Order',
          entityId: input.garmentId,
        ));
      }

      // 3. Get shop info
      final shop = await _shopRepository.getById(order.shopId);

      // 4. Build workflow stages for customer view
      final workflowStages = _workflowStateMachine.getWorkflowStages(order);
      final customerStages = _buildCustomerStages(workflowStages);

      return Result.success(CustomerOrderView(
        garmentIdDisplay: order.garmentId.toString(),
        garmentType: order.garmentType,
        garmentTypeArabic: order.garmentType.arabicName,
        status: order.status,
        statusArabic: order.status.arabicName,
        expectedDeliveryDate: order.expectedDeliveryDate,
        isReady: order.status == GarmentStatus.ready,
        isDelivered: order.status == GarmentStatus.delivered,
        progressPercentage: order.progressPercentage,
        stages: customerStages,
        shopName: shop?.name ?? '',
        shopPhone: shop?.phoneNumber.formatted ?? '',
      ));
    } catch (e) {
      return Result.failure(StorageFailure(
        message: 'Failed to get order: $e',
        arabicMessage: 'فشل في جلب معلومات الطلب',
      ));
    }
  }

  String _normalizePhone(String phone) {
    // Remove all non-digits
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  List<CustomerWorkflowStage> _buildCustomerStages(List<WorkflowStageInfo> stages) {
    // Customer sees simplified stages:
    // 1. Order Received (CREATED)
    // 2. Measured (MEASURED)
    // 3. In Production (CUTTING, SEWING, BUTTONING, IRONING)
    // 4. Ready (READY)
    // 5. Delivered (DELIVERED)
    
    final customerStages = <CustomerWorkflowStage>[];
    
    // Order Received
    final createdStage = stages.firstWhere((s) => s.status == GarmentStatus.created);
    customerStages.add(CustomerWorkflowStage(
      nameArabic: 'تم استلام الطلب',
      nameEnglish: 'Order Received',
      isCompleted: createdStage.isCompleted,
      isCurrent: createdStage.isCurrent,
      stageNumber: 1,
    ));

    // Measured
    final measuredStage = stages.firstWhere((s) => s.status == GarmentStatus.measured);
    customerStages.add(CustomerWorkflowStage(
      nameArabic: 'تم القياس',
      nameEnglish: 'Measured',
      isCompleted: measuredStage.isCompleted,
      isCurrent: measuredStage.isCurrent,
      stageNumber: 2,
    ));

    // In Production (combined)
    final productionStages = stages.where((s) => 
      s.status == GarmentStatus.cutting ||
      s.status == GarmentStatus.sewing ||
      s.status == GarmentStatus.buttoning ||
      s.status == GarmentStatus.ironing
    );
    final inProduction = productionStages.any((s) => s.isCurrent);
    final productionComplete = productionStages.every((s) => s.isCompleted);
    customerStages.add(CustomerWorkflowStage(
      nameArabic: 'قيد التنفيذ',
      nameEnglish: 'In Production',
      isCompleted: productionComplete,
      isCurrent: inProduction,
      stageNumber: 3,
    ));

    // Ready
    final readyStage = stages.firstWhere((s) => s.status == GarmentStatus.ready);
    customerStages.add(CustomerWorkflowStage(
      nameArabic: 'جاهز للاستلام',
      nameEnglish: 'Ready for Pickup',
      isCompleted: readyStage.isCompleted,
      isCurrent: readyStage.isCurrent,
      stageNumber: 4,
    ));

    // Delivered
    final deliveredStage = stages.firstWhere((s) => s.status == GarmentStatus.delivered);
    customerStages.add(CustomerWorkflowStage(
      nameArabic: 'تم التسليم',
      nameEnglish: 'Delivered',
      isCompleted: deliveredStage.isCompleted,
      isCurrent: deliveredStage.isCurrent,
      stageNumber: 5,
    ));

    return customerStages;
  }
}

