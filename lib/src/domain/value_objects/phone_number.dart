import 'package:tailorhouse/src/domain/exceptions/domain_exceptions.dart';

/// Phone number value object
/// 
/// Handles phone number validation and formatting.
/// Supports various formats and normalizes them.
class PhoneNumber {
  /// The normalized phone number (digits only, with country code)
  final String normalizedNumber;
  
  /// Original input (for display purposes)
  final String originalInput;

  /// Country code (e.g., "966" for Saudi Arabia)
  final String countryCode;

  /// Private constructor
  const PhoneNumber._({
    required this.normalizedNumber,
    required this.originalInput,
    required this.countryCode,
  });

  /// Create and validate a phone number
  /// 
  /// Accepts formats:
  /// - +966501234567
  /// - 00966501234567
  /// - 0501234567 (assumes Saudi Arabia)
  /// - 501234567 (assumes Saudi Arabia)
  factory PhoneNumber.create(String input, {String defaultCountryCode = '966'}) {
    final trimmed = input.trim();
    
    if (trimmed.isEmpty) {
      throw InvalidPhoneNumberException('Phone number cannot be empty', input);
    }

    // Remove all non-digit characters except leading +
    String normalized = trimmed;
    
    // Handle different prefix formats
    if (normalized.startsWith('+')) {
      normalized = normalized.substring(1);
    } else if (normalized.startsWith('00')) {
      normalized = normalized.substring(2);
    } else if (normalized.startsWith('0')) {
      // Local format - add default country code
      normalized = defaultCountryCode + normalized.substring(1);
    } else if (!_startsWithCountryCode(normalized)) {
      // No country code - add default
      normalized = defaultCountryCode + normalized;
    }

    // Remove any remaining non-digits
    normalized = normalized.replaceAll(RegExp(r'[^\d]'), '');

    // Validate length (most phone numbers are 10-15 digits including country code)
    if (normalized.length < 10 || normalized.length > 15) {
      throw InvalidPhoneNumberException(
        'Phone number must be 10-15 digits',
        input,
      );
    }

    // Extract country code (assume first 2-3 digits)
    final countryCode = _extractCountryCode(normalized);

    return PhoneNumber._(
      normalizedNumber: normalized,
      originalInput: trimmed,
      countryCode: countryCode,
    );
  }

  /// Try to create, returns null if invalid
  static PhoneNumber? tryCreate(String input, {String defaultCountryCode = '966'}) {
    try {
      return PhoneNumber.create(input, defaultCountryCode: defaultCountryCode);
    } catch (_) {
      return null;
    }
  }

  /// Format for display: +966 50 123 4567
  String get formatted {
    if (normalizedNumber.length >= 12) {
      // Format: +XXX XX XXX XXXX
      final cc = normalizedNumber.substring(0, 3);
      final part1 = normalizedNumber.substring(3, 5);
      final part2 = normalizedNumber.substring(5, 8);
      final part3 = normalizedNumber.substring(8);
      return '+$cc $part1 $part2 $part3';
    }
    return '+$normalizedNumber';
  }

  /// Format for international dialing: +966501234567
  String get international => '+$normalizedNumber';

  /// Format for local display (without country code)
  String get local {
    if (normalizedNumber.startsWith(countryCode)) {
      return '0${normalizedNumber.substring(countryCode.length)}';
    }
    return normalizedNumber;
  }

  /// Format for WhatsApp link
  String get whatsAppLink => 'https://wa.me/$normalizedNumber';

  /// Format for tel: link
  String get telLink => 'tel:+$normalizedNumber';

  /// Check if this is a Saudi number
  bool get isSaudiNumber => countryCode == '966';

  /// Check if this is a mobile number (Saudi-specific check)
  bool get isMobile {
    if (!isSaudiNumber) return true; // Can't verify for other countries
    final localNumber = normalizedNumber.substring(3);
    return localNumber.startsWith('5'); // Saudi mobile numbers start with 5
  }

  static bool _startsWithCountryCode(String number) {
    // Check for common country codes
    final commonCodes = ['966', '971', '973', '974', '965', '968', '1', '44', '49'];
    return commonCodes.any((code) => number.startsWith(code));
  }

  static String _extractCountryCode(String number) {
    // Check for known country codes (in order of length, longest first)
    final countryCodes = ['966', '971', '973', '974', '965', '968', '44', '49', '1'];
    for (final code in countryCodes) {
      if (number.startsWith(code)) {
        return code;
      }
    }
    // Default to first 3 digits
    return number.substring(0, 3);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneNumber && other.normalizedNumber == normalizedNumber;
  }

  @override
  int get hashCode => normalizedNumber.hashCode;

  @override
  String toString() => formatted;
}

