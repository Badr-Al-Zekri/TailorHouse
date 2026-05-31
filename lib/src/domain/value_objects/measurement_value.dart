import 'package:tailorhouse/src/domain/exceptions/domain_exceptions.dart';

/// Measurement value object
/// 
/// Represents a single body measurement with validation.
/// All measurements are stored internally in centimeters.
class MeasurementValue {
  /// The measurement value in centimeters
  final double valueInCm;

  /// Whether this value was captured by AI or entered manually
  final MeasurementSource source;

  /// AI confidence score (0.0 to 1.0), null for manual measurements
  final double? confidence;

  /// Private constructor
  const MeasurementValue._({
    required this.valueInCm,
    required this.source,
    this.confidence,
  });

  /// Create a measurement value in centimeters
  factory MeasurementValue.cm(
    double value, {
    MeasurementSource source = MeasurementSource.manual,
    double? confidence,
  }) {
    _validateValue(value);
    _validateConfidence(confidence, source);

    return MeasurementValue._(
      valueInCm: value,
      source: source,
      confidence: confidence,
    );
  }

  /// Create a measurement value in inches (converts to cm internally)
  factory MeasurementValue.inches(
    double value, {
    MeasurementSource source = MeasurementSource.manual,
    double? confidence,
  }) {
    _validateValue(value * 2.54); // Validate after conversion
    _validateConfidence(confidence, source);

    return MeasurementValue._(
      valueInCm: value * 2.54,
      source: source,
      confidence: confidence,
    );
  }

  /// Create from AI measurement result
  factory MeasurementValue.fromAi(double valueInCm, double confidence) {
    return MeasurementValue.cm(
      valueInCm,
      source: MeasurementSource.ai,
      confidence: confidence,
    );
  }

  /// Create from manual input
  factory MeasurementValue.manual(double valueInCm) {
    return MeasurementValue.cm(
      valueInCm,
      source: MeasurementSource.manual,
    );
  }

  static void _validateValue(double value) {
    if (value <= 0) {
      throw InvalidMeasurementException('Measurement must be positive', value);
    }
    if (value > 500) {
      throw InvalidMeasurementException(
        'Measurement exceeds maximum (500 cm)',
        value,
      );
    }
  }

  static void _validateConfidence(double? confidence, MeasurementSource source) {
    if (source == MeasurementSource.ai && confidence == null) {
      throw InvalidMeasurementException(
        'AI measurements must have a confidence score',
        0,
      );
    }
    if (confidence != null && (confidence < 0 || confidence > 1)) {
      throw InvalidMeasurementException(
        'Confidence must be between 0 and 1',
        confidence,
      );
    }
  }

  /// Get value in inches
  double get valueInInches => valueInCm / 2.54;

  /// Check if this is an AI measurement
  bool get isAiMeasurement => source == MeasurementSource.ai;

  /// Check if this is a manual measurement
  bool get isManualMeasurement => source == MeasurementSource.manual;

  /// Check if confidence is high (>= 80%)
  bool get hasHighConfidence => confidence != null && confidence! >= 0.8;

  /// Check if confidence is acceptable (>= 60%)
  bool get hasAcceptableConfidence => confidence != null && confidence! >= 0.6;

  /// Format for display in cm
  String formatCm({int decimals = 1}) => '${valueInCm.toStringAsFixed(decimals)} سم';

  /// Format for display in inches
  String formatInches({int decimals = 1}) => '${valueInInches.toStringAsFixed(decimals)} إنش';

  /// Create a copy with manual adjustment
  MeasurementValue adjustManually(double newValueInCm) {
    return MeasurementValue.cm(
      newValueInCm,
      source: MeasurementSource.manuallyAdjusted,
      confidence: null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeasurementValue &&
        other.valueInCm == valueInCm &&
        other.source == source;
  }

  @override
  int get hashCode => Object.hash(valueInCm, source);

  @override
  String toString() => formatCm();
}

/// Source of the measurement
enum MeasurementSource {
  /// Entered manually by staff
  manual(arabicName: 'يدوي', englishName: 'Manual'),
  
  /// Captured by AI from images
  ai(arabicName: 'ذكاء اصطناعي', englishName: 'AI'),
  
  /// Originally AI but manually adjusted
  manuallyAdjusted(arabicName: 'معدّل يدوياً', englishName: 'Manually Adjusted');

  final String arabicName;
  final String englishName;

  const MeasurementSource({
    required this.arabicName,
    required this.englishName,
  });
}

