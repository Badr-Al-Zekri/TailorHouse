import 'package:tailorhouse/src/core/constants/app_constants.dart';

/// Order item entity
class OrderItem {
  final String id;
  final String orderId;
  final String name;
  final String description;
  final GarmentType garmentType;
  final double price;
  final int quantity;
  final String? fabricType;
  final String? color;
  final String? measurementProfileId;
  final Map<String, double>? measurements;
  final DateTime createdAt;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.name,
    required this.description,
    required this.garmentType,
    required this.price,
    required this.quantity,
    this.fabricType,
    this.color,
    this.measurementProfileId,
    this.measurements,
    required this.createdAt,
  });

  double get totalPrice => price * quantity;
  double get unitPrice => price;
}

/// Alteration types
enum AlterationType {
  hemming('Hemming', 'Shorten or lengthen garment'),
  takingIn('Taking In', 'Make garment smaller'),
  lettingOut('Letting Out', 'Make garment larger'),
  sleeveAdjustment('Sleeve Adjustment', 'Adjust sleeve length or width'),
  waistAdjustment('Waist Adjustment', 'Adjust waist size'),
  shoulderAdjustment('Shoulder Adjustment', 'Adjust shoulder fit'),
  zipper('Zipper Repair', 'Fix or replace zipper'),
  buttons('Button Repair', 'Fix or replace buttons'),
  lining('Lining Repair', 'Fix or replace lining'),
  other('Other', 'Other alterations');

  final String displayName;
  final String description;

  const AlterationType(this.displayName, this.description);
}

/// Alteration request entity
class AlterationRequest {
  final String id;
  final String userId;
  final String? orderId;
  final List<AlterationType> alterationTypes;
  final String description;
  final List<String> imageUrls;
  final OrderStatus status;
  final double? estimatedCost;
  final DateTime createdAt;
  final DateTime? completedAt;

  const AlterationRequest({
    required this.id,
    required this.userId,
    this.orderId,
    required this.alterationTypes,
    required this.description,
    required this.imageUrls,
    required this.status,
    this.estimatedCost,
    required this.createdAt,
    this.completedAt,
  });
}
