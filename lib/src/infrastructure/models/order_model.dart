import 'package:hive/hive.dart';
import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/infrastructure/models/measurement_model.dart';
import 'package:tailorhouse/src/infrastructure/models/workflow_log_model.dart';

part 'order_model.g.dart';

/// Hive model for Order entity
@HiveType(typeId: 5)
class OrderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String garmentIdString; // Stored as string, parsed when needed

  @HiveField(2)
  final String shopId;

  @HiveField(3)
  final String customerId;

  @HiveField(4)
  final String customerName;

  @HiveField(5)
  final String customerPhone;

  @HiveField(6)
  final int garmentTypeIndex; // GarmentType enum index

  @HiveField(7)
  final String fabricDescription;

  @HiveField(8)
  final String? fabricColor;

  @HiveField(9)
  final int totalPriceInSmallestUnit;

  @HiveField(10)
  final int depositPaidInSmallestUnit;

  @HiveField(11)
  final String currency;

  @HiveField(12)
  final int statusIndex; // GarmentStatus enum index

  @HiveField(13)
  final DateTime expectedDeliveryDate;

  @HiveField(14)
  final DateTime? actualDeliveryDate;

  @HiveField(15)
  final MeasurementModel? measurement;

  @HiveField(16)
  final List<WorkflowLogModel> workflowLogs;

  @HiveField(17)
  final String? notes;

  @HiveField(18)
  final DateTime createdAt;

  @HiveField(19)
  final DateTime updatedAt;

  @HiveField(20)
  final String createdBy;

  OrderModel({
    required this.id,
    required this.garmentIdString,
    required this.shopId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.garmentTypeIndex,
    required this.fabricDescription,
    this.fabricColor,
    required this.totalPriceInSmallestUnit,
    required this.depositPaidInSmallestUnit,
    required this.currency,
    required this.statusIndex,
    required this.expectedDeliveryDate,
    this.actualDeliveryDate,
    this.measurement,
    required this.workflowLogs,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  /// Convert from domain entity
  factory OrderModel.fromEntity(Order entity) {
    return OrderModel(
      id: entity.id,
      garmentIdString: entity.garmentId.toString(),
      shopId: entity.shopId,
      customerId: entity.customerId,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      garmentTypeIndex: entity.garmentType.index,
      fabricDescription: entity.fabricDescription,
      fabricColor: entity.fabricColor,
      totalPriceInSmallestUnit: entity.totalPrice.amountInSmallestUnit,
      depositPaidInSmallestUnit: entity.depositPaid.amountInSmallestUnit,
      currency: entity.totalPrice.currencyCode,
      statusIndex: entity.status.index,
      expectedDeliveryDate: entity.expectedDeliveryDate,
      actualDeliveryDate: entity.actualDeliveryDate,
      measurement: entity.measurement != null
          ? MeasurementModel.fromEntity(entity.measurement!)
          : null,
      workflowLogs: entity.workflowLogs
          .map((log) => WorkflowLogModel.fromEntity(log))
          .toList(),
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
    );
  }

  /// Convert to domain entity
  Order toEntity() {
    return Order(
      id: id,
      garmentId: GarmentId.parse(garmentIdString),
      shopId: shopId,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      garmentType: GarmentType.values[garmentTypeIndex],
      fabricDescription: fabricDescription,
      fabricColor: fabricColor,
      totalPrice: Money.fromSmallestUnit(
        totalPriceInSmallestUnit,
        currency: currency,
      ),
      depositPaid: Money.fromSmallestUnit(
        depositPaidInSmallestUnit,
        currency: currency,
      ),
      status: GarmentStatus.values[statusIndex],
      expectedDeliveryDate: expectedDeliveryDate,
      actualDeliveryDate: actualDeliveryDate,
      measurement: measurement?.toEntity(),
      workflowLogs: workflowLogs.map((log) => log.toEntity()).toList(),
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
    );
  }
}

