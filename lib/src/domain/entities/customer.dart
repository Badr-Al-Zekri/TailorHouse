import 'package:tailorhouse/src/domain/value_objects/phone_number.dart';

/// Customer entity
/// 
/// Represents a customer who places orders at the tailoring shop.
class Customer {
  /// Unique identifier
  final String id;

  /// Customer's full name
  final String name;

  /// Primary phone number
  final PhoneNumber phoneNumber;

  /// Optional secondary phone number
  final PhoneNumber? secondaryPhoneNumber;

  /// Optional notes about the customer
  final String? notes;

  /// When the customer was first registered
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  const Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.secondaryPhoneNumber,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new customer
  factory Customer.create({
    required String id,
    required String name,
    required PhoneNumber phoneNumber,
    PhoneNumber? secondaryPhoneNumber,
    String? notes,
  }) {
    final now = DateTime.now();
    return Customer(
      id: id,
      name: name.trim(),
      phoneNumber: phoneNumber,
      secondaryPhoneNumber: secondaryPhoneNumber,
      notes: notes?.trim(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Update customer information
  Customer update({
    String? name,
    PhoneNumber? phoneNumber,
    PhoneNumber? secondaryPhoneNumber,
    String? notes,
  }) {
    return Customer(
      id: id,
      name: name?.trim() ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      secondaryPhoneNumber: secondaryPhoneNumber ?? this.secondaryPhoneNumber,
      notes: notes?.trim() ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// Get display name (for UI)
  String get displayName => name;

  /// Get formatted phone for display
  String get formattedPhone => phoneNumber.formatted;

  /// Get WhatsApp link
  String get whatsAppLink => phoneNumber.whatsAppLink;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Customer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Customer($id, $name)';
}

