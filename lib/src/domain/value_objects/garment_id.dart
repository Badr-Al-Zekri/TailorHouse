import 'package:tailorhouse/src/domain/exceptions/domain_exceptions.dart';

/// Garment Identity - Human-readable unique identifier
/// 
/// Format: [SHOP_CODE]-[YY]-[SEQUENCE]
/// Example: TF01-25-00458
/// 
/// Business Rules:
/// - SHOP_CODE: Fixed internal identifier (not display name), 2-6 alphanumeric chars
/// - YY: Two-digit year
/// - SEQUENCE: Zero-padded sequence number (5 digits, max 99999 per year)
/// 
/// Properties:
/// - Human-readable and manually writable
/// - Independent of shop display name
/// - Convertible to QR/Barcode without format change
/// - Stable even if shop name changes
class GarmentId {
  final String shopCode;
  final int year;
  final int sequence;

  /// Private constructor - use factory methods
  const GarmentId._({
    required this.shopCode,
    required this.year,
    required this.sequence,
  });

  /// Create a new GarmentId with validation
  factory GarmentId.create({
    required String shopCode,
    required int year,
    required int sequence,
  }) {
    // Validate shop code
    if (shopCode.isEmpty || shopCode.length < 2 || shopCode.length > 6) {
      throw InvalidGarmentIdException(
        'Shop code must be 2-6 characters',
        invalidValue: shopCode,
      );
    }
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(shopCode.toUpperCase())) {
      throw InvalidGarmentIdException(
        'Shop code must be alphanumeric only',
        invalidValue: shopCode,
      );
    }

    // Validate year (reasonable range)
    if (year < 20 || year > 99) {
      throw InvalidGarmentIdException(
        'Year must be between 20 and 99',
        invalidValue: year.toString(),
      );
    }

    // Validate sequence
    if (sequence < 1 || sequence > 99999) {
      throw InvalidGarmentIdException(
        'Sequence must be between 1 and 99999',
        invalidValue: sequence.toString(),
      );
    }

    return GarmentId._(
      shopCode: shopCode.toUpperCase(),
      year: year,
      sequence: sequence,
    );
  }

  /// Parse a GarmentId from its string representation
  /// Format: SHOP_CODE-YY-SEQUENCE
  factory GarmentId.parse(String value) {
    final trimmed = value.trim().toUpperCase();
    final parts = trimmed.split('-');

    if (parts.length != 3) {
      throw InvalidGarmentIdException(
        'Invalid format. Expected: SHOP_CODE-YY-SEQUENCE',
        invalidValue: value,
      );
    }

    final shopCode = parts[0];
    final yearStr = parts[1];
    final sequenceStr = parts[2];

    // Parse year
    final year = int.tryParse(yearStr);
    if (year == null) {
      throw InvalidGarmentIdException(
        'Invalid year format',
        invalidValue: value,
      );
    }

    // Parse sequence
    final sequence = int.tryParse(sequenceStr);
    if (sequence == null) {
      throw InvalidGarmentIdException(
        'Invalid sequence format',
        invalidValue: value,
      );
    }

    return GarmentId.create(
      shopCode: shopCode,
      year: year,
      sequence: sequence,
    );
  }

  /// Try to parse, returns null if invalid
  static GarmentId? tryParse(String value) {
    try {
      return GarmentId.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Get the full string representation
  /// Format: TF01-25-00458
  @override
  String toString() {
    final yearStr = year.toString().padLeft(2, '0');
    final sequenceStr = sequence.toString().padLeft(5, '0');
    return '$shopCode-$yearStr-$sequenceStr';
  }

  /// Get short display format (for labels)
  String get shortDisplay => toString();

  /// Get the value suitable for QR/Barcode encoding
  /// Currently same as toString, but abstracted for future changes
  String get barcodeValue => toString();

  /// Check if this ID belongs to a specific shop
  bool belongsToShop(String code) => shopCode == code.toUpperCase();

  /// Check if this ID is from a specific year
  bool isFromYear(int y) => year == y;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GarmentId &&
        other.shopCode == shopCode &&
        other.year == year &&
        other.sequence == sequence;
  }

  @override
  int get hashCode => Object.hash(shopCode, year, sequence);
}

/// Service for generating new GarmentIds
/// 
/// This is a pure domain service - actual sequence retrieval
/// is delegated to repository through the callback.
class GarmentIdGenerator {
  final String shopCode;

  const GarmentIdGenerator({required this.shopCode});

  /// Generate the next GarmentId
  /// 
  /// [currentYear] - Two-digit year (e.g., 25 for 2025)
  /// [lastSequence] - The last used sequence number for this shop+year
  ///                  Pass 0 if this is the first garment of the year
  GarmentId generateNext({
    required int currentYear,
    required int lastSequence,
  }) {
    final nextSequence = lastSequence + 1;

    if (nextSequence > 99999) {
      throw GarmentIdSequenceExhaustedException(
        shopCode: shopCode,
        year: currentYear,
      );
    }

    return GarmentId.create(
      shopCode: shopCode,
      year: currentYear,
      sequence: nextSequence,
    );
  }

  /// Validate that a shop code is properly formatted
  static bool isValidShopCode(String code) {
    if (code.isEmpty || code.length < 2 || code.length > 6) return false;
    return RegExp(r'^[A-Z0-9]+$').hasMatch(code.toUpperCase());
  }
}

