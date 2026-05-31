import 'package:equatable/equatable.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/body_measurement.dart';

/// Represents a saved measurement profile
class MeasurementProfile extends Equatable {
  final String id;
  final String userId;
  final String name;
  final double height; // in cm
  final double weight; // in kg
  final Map<String, BodyMeasurement> measurements;
  final MeasurementSource source;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const MeasurementProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.height,
    required this.weight,
    required this.measurements,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  /// Create a copy with updated fields
  MeasurementProfile copyWith({
    String? id,
    String? userId,
    String? name,
    double? height,
    double? weight,
    Map<String, BodyMeasurement>? measurements,
    MeasurementSource? source,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return MeasurementProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      measurements: measurements ?? this.measurements,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  /// Get a specific measurement by body part key
  BodyMeasurement? getMeasurement(String bodyPart) {
    return measurements[bodyPart];
  }

  /// Check if profile has all essential measurements
  bool get isComplete {
    const essentialParts = ['chest', 'waist', 'hip', 'shoulder'];
    return essentialParts.every((part) => measurements.containsKey(part));
  }

  /// Get the number of measurements recorded
  int get measurementCount => measurements.length;

  /// Calculate BMI
  double get bmi {
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        height,
        weight,
        measurements,
        source,
        createdAt,
        updatedAt,
        isSynced,
      ];
}

/// Source of the measurement
enum MeasurementSource {
  manual('Manual'),
  aiAssisted('AI Assisted'),
  imported('Imported');

  final String displayName;
  const MeasurementSource(this.displayName);
}

