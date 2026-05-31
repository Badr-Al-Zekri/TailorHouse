import 'package:tailorhouse/src/domain/value_objects/measurement_value.dart';
import 'package:tailorhouse/src/domain/enums/garment_type.dart';
import 'package:tailorhouse/src/domain/exceptions/domain_exceptions.dart';

/// Measurement entity
/// 
/// Contains all body measurements for an order.
/// Can be captured via AI (from images) or entered manually.
class Measurement {
  /// Unique identifier
  final String id;

  /// Associated order ID
  final String orderId;

  /// Body height (cm)
  final MeasurementValue? height;

  /// Shoulder width (cm)
  final MeasurementValue? shoulder;

  /// Chest circumference (cm)
  final MeasurementValue? chest;

  /// Waist circumference (cm)
  final MeasurementValue? waist;

  /// Hip circumference (cm)
  final MeasurementValue? hips;

  /// Sleeve length (cm)
  final MeasurementValue? sleeveLength;

  /// Trouser length (cm)
  final MeasurementValue? trouserLength;

  /// Thobe length (cm)
  final MeasurementValue? thobeLength;

  /// Neck circumference (cm)
  final MeasurementValue? neck;

  /// Arm length (cm)
  final MeasurementValue? armLength;

  /// Wrist circumference (cm)
  final MeasurementValue? wrist;

  /// Inseam length (cm)
  final MeasurementValue? inseam;

  /// Additional custom measurements
  final Map<String, MeasurementValue> customMeasurements;

  /// Paths/URLs to captured images (front, side, back)
  final List<String> imagePaths;

  /// When the measurement was taken
  final DateTime measuredAt;

  /// Who took the measurement (user ID)
  final String measuredBy;

  /// Optional notes
  final String? notes;

  const Measurement({
    required this.id,
    required this.orderId,
    this.height,
    this.shoulder,
    this.chest,
    this.waist,
    this.hips,
    this.sleeveLength,
    this.trouserLength,
    this.thobeLength,
    this.neck,
    this.armLength,
    this.wrist,
    this.inseam,
    this.customMeasurements = const {},
    this.imagePaths = const [],
    required this.measuredAt,
    required this.measuredBy,
    this.notes,
  });

  /// Create a new measurement record
  factory Measurement.create({
    required String id,
    required String orderId,
    required String measuredBy,
    MeasurementValue? height,
    MeasurementValue? shoulder,
    MeasurementValue? chest,
    MeasurementValue? waist,
    MeasurementValue? hips,
    MeasurementValue? sleeveLength,
    MeasurementValue? trouserLength,
    MeasurementValue? thobeLength,
    MeasurementValue? neck,
    MeasurementValue? armLength,
    MeasurementValue? wrist,
    MeasurementValue? inseam,
    Map<String, MeasurementValue>? customMeasurements,
    List<String>? imagePaths,
    String? notes,
  }) {
    return Measurement(
      id: id,
      orderId: orderId,
      height: height,
      shoulder: shoulder,
      chest: chest,
      waist: waist,
      hips: hips,
      sleeveLength: sleeveLength,
      trouserLength: trouserLength,
      thobeLength: thobeLength,
      neck: neck,
      armLength: armLength,
      wrist: wrist,
      inseam: inseam,
      customMeasurements: customMeasurements ?? {},
      imagePaths: imagePaths ?? [],
      measuredAt: DateTime.now(),
      measuredBy: measuredBy,
      notes: notes?.trim(),
    );
  }

  /// Check if this measurement is from AI
  bool get isAiMeasurement {
    final allValues = _getAllValues();
    return allValues.any((v) => v.isAiMeasurement);
  }

  /// Check if all measurements are manual
  bool get isManualMeasurement {
    final allValues = _getAllValues();
    return allValues.every((v) => v.isManualMeasurement);
  }

  /// Check if images are attached
  bool get hasImages => imagePaths.isNotEmpty;

  /// Get front image path (first image by convention)
  String? get frontImagePath => imagePaths.isNotEmpty ? imagePaths[0] : null;

  /// Get side image path (second image by convention)
  String? get sideImagePath => imagePaths.length > 1 ? imagePaths[1] : null;

  /// Get back image path (third image by convention)
  String? get backImagePath => imagePaths.length > 2 ? imagePaths[2] : null;

  /// Validate that required measurements are present for a garment type
  void validateForGarmentType(GarmentType type) {
    final required = _getRequiredMeasurements(type);
    final missing = <String>[];

    for (final field in required) {
      if (!_hasMeasurement(field)) {
        missing.add(field);
      }
    }

    if (missing.isNotEmpty) {
      throw MissingRequiredMeasurementsException(missing);
    }
  }

  /// Check if a specific measurement is present
  bool _hasMeasurement(String field) {
    switch (field) {
      case 'height': return height != null;
      case 'shoulder': return shoulder != null;
      case 'chest': return chest != null;
      case 'waist': return waist != null;
      case 'hips': return hips != null;
      case 'sleeveLength': return sleeveLength != null;
      case 'trouserLength': return trouserLength != null;
      case 'thobeLength': return thobeLength != null;
      case 'neck': return neck != null;
      default: return customMeasurements.containsKey(field);
    }
  }

  /// Get required measurements for a garment type
  List<String> _getRequiredMeasurements(GarmentType type) {
    switch (type) {
      case GarmentType.thobe:
        return ['shoulder', 'chest', 'thobeLength', 'sleeveLength'];
      case GarmentType.shirt:
        return ['shoulder', 'chest', 'sleeveLength'];
      case GarmentType.trousers:
        return ['waist', 'hips', 'trouserLength'];
      case GarmentType.suit:
        return ['shoulder', 'chest', 'waist', 'sleeveLength', 'trouserLength'];
      case GarmentType.jacket:
        return ['shoulder', 'chest', 'sleeveLength'];
      case GarmentType.abaya:
        return ['shoulder', 'chest', 'height'];
      case GarmentType.dress:
        return ['shoulder', 'chest', 'waist', 'hips', 'height'];
      case GarmentType.jalabiya:
        return ['shoulder', 'chest', 'height'];
      case GarmentType.other:
        return ['chest']; // Minimal requirement
    }
  }

  /// Get all non-null measurement values
  List<MeasurementValue> _getAllValues() {
    return [
      height,
      shoulder,
      chest,
      waist,
      hips,
      sleeveLength,
      trouserLength,
      thobeLength,
      neck,
      armLength,
      wrist,
      inseam,
      ...customMeasurements.values,
    ].whereType<MeasurementValue>().toList();
  }

  /// Get average confidence (for AI measurements)
  double? get averageConfidence {
    final aiValues = _getAllValues().where((v) => v.confidence != null).toList();
    if (aiValues.isEmpty) return null;
    return aiValues.map((v) => v.confidence!).reduce((a, b) => a + b) / aiValues.length;
  }

  /// Create a copy with updated values
  Measurement copyWith({
    MeasurementValue? height,
    MeasurementValue? shoulder,
    MeasurementValue? chest,
    MeasurementValue? waist,
    MeasurementValue? hips,
    MeasurementValue? sleeveLength,
    MeasurementValue? trouserLength,
    MeasurementValue? thobeLength,
    MeasurementValue? neck,
    MeasurementValue? armLength,
    MeasurementValue? wrist,
    MeasurementValue? inseam,
    Map<String, MeasurementValue>? customMeasurements,
    List<String>? imagePaths,
    String? notes,
  }) {
    return Measurement(
      id: id,
      orderId: orderId,
      height: height ?? this.height,
      shoulder: shoulder ?? this.shoulder,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      sleeveLength: sleeveLength ?? this.sleeveLength,
      trouserLength: trouserLength ?? this.trouserLength,
      thobeLength: thobeLength ?? this.thobeLength,
      neck: neck ?? this.neck,
      armLength: armLength ?? this.armLength,
      wrist: wrist ?? this.wrist,
      inseam: inseam ?? this.inseam,
      customMeasurements: customMeasurements ?? this.customMeasurements,
      imagePaths: imagePaths ?? this.imagePaths,
      measuredAt: measuredAt,
      measuredBy: measuredBy,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Measurement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Measurement($id, orderId: $orderId)';
}

