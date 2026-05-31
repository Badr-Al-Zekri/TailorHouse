import 'package:tailorhouse/src/domain/exceptions/domain_exceptions.dart';

/// Money value object for handling prices, deposits, and payments
/// 
/// Represents a monetary amount with currency.
/// Uses integer-based storage (in smallest unit) to avoid floating point issues.
class Money {
  /// Amount in smallest currency unit (e.g., cents, halalah)
  final int amountInSmallestUnit;
  
  /// Currency code (ISO 4217)
  final String currencyCode;

  /// Number of decimal places for this currency
  final int decimalPlaces;

  /// Private constructor
  const Money._({
    required this.amountInSmallestUnit,
    required this.currencyCode,
    required this.decimalPlaces,
  });

  /// Create Money from a decimal amount
  factory Money.fromAmount(double amount, {String currency = 'SAR'}) {
    if (amount < 0) {
      throw InvalidMoneyException('Amount cannot be negative', amount);
    }

    final decimalPlaces = _getDecimalPlaces(currency);
    final multiplier = _getMultiplier(decimalPlaces);
    final smallestUnit = (amount * multiplier).round();

    return Money._(
      amountInSmallestUnit: smallestUnit,
      currencyCode: currency,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Create Money from smallest unit (e.g., cents)
  factory Money.fromSmallestUnit(int amount, {String currency = 'SAR'}) {
    if (amount < 0) {
      throw InvalidMoneyException('Amount cannot be negative', amount.toDouble());
    }

    return Money._(
      amountInSmallestUnit: amount,
      currencyCode: currency,
      decimalPlaces: _getDecimalPlaces(currency),
    );
  }

  /// Create zero money
  factory Money.zero({String currency = 'SAR'}) {
    return Money.fromSmallestUnit(0, currency: currency);
  }

  /// Get the decimal amount
  double get amount => amountInSmallestUnit / _getMultiplier(decimalPlaces);

  /// Check if this is zero
  bool get isZero => amountInSmallestUnit == 0;

  /// Check if this is positive
  bool get isPositive => amountInSmallestUnit > 0;

  /// Add two money amounts (must be same currency)
  Money operator +(Money other) {
    _assertSameCurrency(other);
    return Money._(
      amountInSmallestUnit: amountInSmallestUnit + other.amountInSmallestUnit,
      currencyCode: currencyCode,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Subtract two money amounts (must be same currency)
  Money operator -(Money other) {
    _assertSameCurrency(other);
    final result = amountInSmallestUnit - other.amountInSmallestUnit;
    if (result < 0) {
      throw InvalidMoneyException('Result cannot be negative', result.toDouble());
    }
    return Money._(
      amountInSmallestUnit: result,
      currencyCode: currencyCode,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Multiply by a factor
  Money multiply(double factor) {
    if (factor < 0) {
      throw InvalidMoneyException('Factor cannot be negative', factor);
    }
    return Money._(
      amountInSmallestUnit: (amountInSmallestUnit * factor).round(),
      currencyCode: currencyCode,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Compare two money amounts
  bool operator >(Money other) {
    _assertSameCurrency(other);
    return amountInSmallestUnit > other.amountInSmallestUnit;
  }

  bool operator <(Money other) {
    _assertSameCurrency(other);
    return amountInSmallestUnit < other.amountInSmallestUnit;
  }

  bool operator >=(Money other) {
    _assertSameCurrency(other);
    return amountInSmallestUnit >= other.amountInSmallestUnit;
  }

  bool operator <=(Money other) {
    _assertSameCurrency(other);
    return amountInSmallestUnit <= other.amountInSmallestUnit;
  }

  void _assertSameCurrency(Money other) {
    if (currencyCode != other.currencyCode) {
      throw CurrencyMismatchException(currencyCode, other.currencyCode);
    }
  }

  /// Format for display (e.g., "150.00 SAR")
  String format({bool showCurrency = true}) {
    final formatted = amount.toStringAsFixed(decimalPlaces);
    return showCurrency ? '$formatted $currencyCode' : formatted;
  }

  /// Format with Arabic currency name
  String formatArabic() {
    final formatted = amount.toStringAsFixed(decimalPlaces);
    final arabicCurrency = _getArabicCurrencyName(currencyCode);
    return '$formatted $arabicCurrency';
  }

  static int _getDecimalPlaces(String currency) {
    // Most currencies use 2 decimal places
    // Add specific cases as needed
    switch (currency) {
      case 'KWD':
      case 'BHD':
      case 'OMR':
        return 3;
      case 'JPY':
        return 0;
      default:
        return 2;
    }
  }

  static int _getMultiplier(int decimalPlaces) {
    int result = 1;
    for (int i = 0; i < decimalPlaces; i++) {
      result *= 10;
    }
    return result;
  }

  static String _getArabicCurrencyName(String code) {
    switch (code) {
      case 'SAR':
        return 'ريال';
      case 'AED':
        return 'درهم';
      case 'KWD':
        return 'دينار';
      case 'USD':
        return 'دولار';
      case 'EUR':
        return 'يورو';
      default:
        return code;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Money &&
        other.amountInSmallestUnit == amountInSmallestUnit &&
        other.currencyCode == currencyCode;
  }

  @override
  int get hashCode => Object.hash(amountInSmallestUnit, currencyCode);

  @override
  String toString() => format();
}

