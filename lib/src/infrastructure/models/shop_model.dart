import 'package:hive/hive.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'shop_model.g.dart';

/// Hive model for Shop entity
@HiveType(typeId: 0)
class ShopModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String code;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String? address;

  @HiveField(5)
  final String currency;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final Map<int, int> yearlySequences;

  ShopModel({
    required this.id,
    required this.code,
    required this.name,
    required this.phoneNumber,
    this.address,
    required this.currency,
    required this.createdAt,
    required this.yearlySequences,
  });

  /// Convert from domain entity
  factory ShopModel.fromEntity(Shop entity) {
    return ShopModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      phoneNumber: entity.phoneNumber.international,
      address: entity.address,
      currency: entity.currency,
      createdAt: entity.createdAt,
      yearlySequences: Map<int, int>.from(entity.yearlySequences),
    );
  }

  /// Convert to domain entity
  Shop toEntity() {
    return Shop(
      id: id,
      code: code,
      name: name,
      phoneNumber: PhoneNumber.create(phoneNumber),
      address: address,
      currency: currency,
      createdAt: createdAt,
      yearlySequences: Map<int, int>.from(yearlySequences),
    );
  }

  /// Create a copy with updated fields
  ShopModel copyWith({
    String? name,
    String? phoneNumber,
    String? address,
    Map<int, int>? yearlySequences,
  }) {
    return ShopModel(
      id: id,
      code: code,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      currency: currency,
      createdAt: createdAt,
      yearlySequences: yearlySequences ?? this.yearlySequences,
    );
  }
}

