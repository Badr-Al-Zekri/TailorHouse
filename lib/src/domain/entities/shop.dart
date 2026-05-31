import 'package:tailorhouse/src/domain/value_objects/phone_number.dart';

/// Shop entity
/// 
/// Represents a tailoring shop in the system.
/// The shop code is the critical identifier used in garment IDs.
class Shop {
  /// Unique identifier
  final String id;

  /// Internal shop code (used in garment IDs)
  /// Format: 2-6 alphanumeric characters
  /// Example: "TF01"
  /// This MUST remain stable even if shop name changes
  final String code;

  /// Display name of the shop
  final String name;

  /// Shop phone number
  final PhoneNumber phoneNumber;

  /// Optional address
  final String? address;

  /// Default currency for the shop
  final String currency;

  /// When the shop was registered
  final DateTime createdAt;

  /// Last sequence number used for garment IDs this year
  /// Used by GarmentIdGenerator
  final Map<int, int> yearlySequences;

  const Shop({
    required this.id,
    required this.code,
    required this.name,
    required this.phoneNumber,
    this.address,
    this.currency = 'SAR',
    required this.createdAt,
    this.yearlySequences = const {},
  });

  /// Create a new shop
  factory Shop.create({
    required String id,
    required String code,
    required String name,
    required PhoneNumber phoneNumber,
    String? address,
    String currency = 'SAR',
  }) {
    // Validate shop code
    if (code.isEmpty || code.length < 2 || code.length > 6) {
      throw ArgumentError('Shop code must be 2-6 characters');
    }
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(code.toUpperCase())) {
      throw ArgumentError('Shop code must be alphanumeric only');
    }

    return Shop(
      id: id,
      code: code.toUpperCase(),
      name: name.trim(),
      phoneNumber: phoneNumber,
      address: address?.trim(),
      currency: currency,
      createdAt: DateTime.now(),
      yearlySequences: {},
    );
  }

  /// Get the last sequence number for a specific year
  int getLastSequenceForYear(int year) {
    return yearlySequences[year] ?? 0;
  }

  /// Create a copy with updated sequence
  Shop withUpdatedSequence(int year, int sequence) {
    final newSequences = Map<int, int>.from(yearlySequences);
    newSequences[year] = sequence;
    return Shop(
      id: id,
      code: code,
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      currency: currency,
      createdAt: createdAt,
      yearlySequences: newSequences,
    );
  }

  /// Update shop information (name, address, phone)
  /// Note: code cannot be changed after creation
  Shop update({
    String? name,
    PhoneNumber? phoneNumber,
    String? address,
  }) {
    return Shop(
      id: id,
      code: code, // Code never changes
      name: name?.trim() ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address?.trim() ?? this.address,
      currency: currency,
      createdAt: createdAt,
      yearlySequences: yearlySequences,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Shop && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Shop($code, $name)';
}

