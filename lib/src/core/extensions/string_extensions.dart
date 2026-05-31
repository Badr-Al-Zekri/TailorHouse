/// Extension methods for String
extension StringExtensions on String {
  // ============================================================================
  // Validation
  // ============================================================================

  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s-]{8,15}$');
    return phoneRegex.hasMatch(this);
  }

  bool get isNumeric {
    final numericRegex = RegExp(r'^-?\d+\.?\d*$');
    return numericRegex.hasMatch(this);
  }

  bool get isAlphanumeric {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(this);
  }

  // ============================================================================
  // Transformation
  // ============================================================================

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get camelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[\s_-]+'));
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalize).join();
  }

  String get snakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  String get titleCase {
    return toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  // ============================================================================
  // Sanitization
  // ============================================================================

  String get trimAll => replaceAll(RegExp(r'\s+'), ' ').trim();

  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  String get digitsOnly => replaceAll(RegExp(r'[^\d]'), '');

  String get lettersOnly => replaceAll(RegExp(r'[^a-zA-Z]'), '');

  // ============================================================================
  // Truncation
  // ============================================================================

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  // ============================================================================
  // Nullable/Empty helpers
  // ============================================================================

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  String? get nullIfEmpty => isEmpty ? null : this;

  String? get nullIfBlank => isBlank ? null : this;

  String get orEmpty => this;

  // ============================================================================
  // Parsing
  // ============================================================================

  int? get toIntOrNull => int.tryParse(this);

  double? get toDoubleOrNull => double.tryParse(this);

  int toIntOr(int fallback) => int.tryParse(this) ?? fallback;

  double toDoubleOr(double fallback) => double.tryParse(this) ?? fallback;

  // ============================================================================
  // Masking (for sensitive data)
  // ============================================================================

  String get maskEmail {
    if (!contains('@')) return this;
    final parts = split('@');
    final name = parts[0];
    final domain = parts[1];
    final maskedName = name.length > 2
        ? '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}'
        : name;
    return '$maskedName@$domain';
  }

  String get maskPhone {
    if (length < 4) return this;
    return '${'*' * (length - 4)}${substring(length - 4)}';
  }
}

/// Extension methods for nullable String
extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNullOrBlank => this == null || this!.isBlank;

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  bool get isNotNullOrBlank => !isNullOrBlank;

  String orEmpty() => this ?? '';

  String or(String fallback) => this ?? fallback;
}

