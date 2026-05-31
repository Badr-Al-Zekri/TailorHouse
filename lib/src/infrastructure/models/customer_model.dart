import 'package:hive/hive.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'customer_model.g.dart';

/// Hive model for Customer entity
@HiveType(typeId: 1)
class CustomerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String shopId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String? secondaryPhoneNumber;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  CustomerModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.phoneNumber,
    this.secondaryPhoneNumber,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from domain entity
  factory CustomerModel.fromEntity(Customer entity, String shopId) {
    return CustomerModel(
      id: entity.id,
      shopId: shopId,
      name: entity.name,
      phoneNumber: entity.phoneNumber.international,
      secondaryPhoneNumber: entity.secondaryPhoneNumber?.international,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert to domain entity
  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      phoneNumber: PhoneNumber.create(phoneNumber),
      secondaryPhoneNumber: secondaryPhoneNumber != null
          ? PhoneNumber.create(secondaryPhoneNumber!)
          : null,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

