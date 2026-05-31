import 'package:equatable/equatable.dart';

/// Represents a single body measurement
class BodyMeasurement extends Equatable {
  final String bodyPart;
  final double value; // in cm
  final double? confidence; // 0-1, only for AI measurements
  final DateTime measuredAt;
  final bool isManuallyEdited;

  const BodyMeasurement({
    required this.bodyPart,
    required this.value,
    this.confidence,
    required this.measuredAt,
    this.isManuallyEdited = false,
  });

  /// Create a copy with updated fields
  BodyMeasurement copyWith({
    String? bodyPart,
    double? value,
    double? confidence,
    DateTime? measuredAt,
    bool? isManuallyEdited,
  }) {
    return BodyMeasurement(
      bodyPart: bodyPart ?? this.bodyPart,
      value: value ?? this.value,
      confidence: confidence ?? this.confidence,
      measuredAt: measuredAt ?? this.measuredAt,
      isManuallyEdited: isManuallyEdited ?? this.isManuallyEdited,
    );
  }

  /// Convert to inches
  double get valueInInches => value / 2.54;

  /// Check if confidence is high (>= 80%)
  bool get hasHighConfidence => confidence != null && confidence! >= 0.8;

  /// Check if this is an AI measurement
  bool get isAiMeasurement => confidence != null;

  /// Format value for display
  String get formattedValue => '${value.toStringAsFixed(1)} cm';

  /// Format value in inches
  String get formattedValueInches => '${valueInInches.toStringAsFixed(1)} in';

  @override
  List<Object?> get props => [
        bodyPart,
        value,
        confidence,
        measuredAt,
        isManuallyEdited,
      ];
}

/// Body part definitions with metadata
class BodyPartInfo {
  final String key;
  final String displayName;
  final String description;
  final String? imageAsset;
  final double minValue;
  final double maxValue;
  final double typicalMin;
  final double typicalMax;

  const BodyPartInfo({
    required this.key,
    required this.displayName,
    required this.description,
    this.imageAsset,
    required this.minValue,
    required this.maxValue,
    required this.typicalMin,
    required this.typicalMax,
  });

  /// Validate if a value is within acceptable range
  bool isValidValue(double value) => value >= minValue && value <= maxValue;

  /// Check if value is typical
  bool isTypicalValue(double value) => value >= typicalMin && value <= typicalMax;
}

/// Predefined body parts with their metadata
class BodyParts {
  BodyParts._();

  static const neck = BodyPartInfo(
    key: 'neck',
    displayName: 'Neck',
    description: 'Measure around the base of the neck',
    minValue: 20,
    maxValue: 60,
    typicalMin: 30,
    typicalMax: 50,
  );

  static const shoulder = BodyPartInfo(
    key: 'shoulder',
    displayName: 'Shoulder',
    description: 'Measure from shoulder to shoulder across the back',
    minValue: 30,
    maxValue: 70,
    typicalMin: 38,
    typicalMax: 55,
  );

  static const chest = BodyPartInfo(
    key: 'chest',
    displayName: 'Chest',
    description: 'Measure around the fullest part of the chest',
    minValue: 60,
    maxValue: 160,
    typicalMin: 80,
    typicalMax: 130,
  );

  static const waist = BodyPartInfo(
    key: 'waist',
    displayName: 'Waist',
    description: 'Measure around the natural waistline',
    minValue: 50,
    maxValue: 150,
    typicalMin: 60,
    typicalMax: 120,
  );

  static const hip = BodyPartInfo(
    key: 'hip',
    displayName: 'Hip',
    description: 'Measure around the fullest part of the hips',
    minValue: 60,
    maxValue: 170,
    typicalMin: 85,
    typicalMax: 130,
  );

  static const armLength = BodyPartInfo(
    key: 'arm_length',
    displayName: 'Arm Length',
    description: 'Measure from shoulder to wrist',
    minValue: 40,
    maxValue: 90,
    typicalMin: 50,
    typicalMax: 70,
  );

  static const wrist = BodyPartInfo(
    key: 'wrist',
    displayName: 'Wrist',
    description: 'Measure around the wrist',
    minValue: 10,
    maxValue: 30,
    typicalMin: 14,
    typicalMax: 22,
  );

  static const thigh = BodyPartInfo(
    key: 'thigh',
    displayName: 'Thigh',
    description: 'Measure around the fullest part of the thigh',
    minValue: 30,
    maxValue: 90,
    typicalMin: 45,
    typicalMax: 75,
  );

  static const inseam = BodyPartInfo(
    key: 'inseam',
    displayName: 'Inseam',
    description: 'Measure from crotch to ankle',
    minValue: 50,
    maxValue: 100,
    typicalMin: 70,
    typicalMax: 90,
  );

  static const outseam = BodyPartInfo(
    key: 'outseam',
    displayName: 'Outseam',
    description: 'Measure from waist to ankle along the outer leg',
    minValue: 80,
    maxValue: 130,
    typicalMin: 95,
    typicalMax: 115,
  );

  static const calf = BodyPartInfo(
    key: 'calf',
    displayName: 'Calf',
    description: 'Measure around the fullest part of the calf',
    minValue: 20,
    maxValue: 60,
    typicalMin: 30,
    typicalMax: 50,
  );

  static const ankle = BodyPartInfo(
    key: 'ankle',
    displayName: 'Ankle',
    description: 'Measure around the ankle',
    minValue: 15,
    maxValue: 40,
    typicalMin: 20,
    typicalMax: 30,
  );

  /// Get all body parts as a list
  static List<BodyPartInfo> get all => [
        neck,
        shoulder,
        chest,
        waist,
        hip,
        armLength,
        wrist,
        thigh,
        inseam,
        outseam,
        calf,
        ankle,
      ];

  /// Get body part by key
  static BodyPartInfo? getByKey(String key) {
    try {
      return all.firstWhere((part) => part.key == key);
    } catch (_) {
      return null;
    }
  }

  /// Get essential body parts for basic measurements
  static List<BodyPartInfo> get essential => [
        chest,
        waist,
        hip,
        shoulder,
      ];

  /// Get upper body measurements
  static List<BodyPartInfo> get upperBody => [
        neck,
        shoulder,
        chest,
        waist,
        armLength,
        wrist,
      ];

  /// Get lower body measurements
  static List<BodyPartInfo> get lowerBody => [
        hip,
        thigh,
        inseam,
        outseam,
        calf,
        ankle,
      ];
}

