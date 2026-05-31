import 'package:hive/hive.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/body_measurement.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/measurement_profile.dart';

// TODO: Run `flutter pub run build_runner build` to generate this file
// part 'measurement_profile_model.g.dart';

@HiveType(typeId: 1)
class MeasurementProfileModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final double height;

  @HiveField(4)
  final double weight;

  @HiveField(5)
  final Map<String, BodyMeasurementModel> measurements;

  @HiveField(6)
  final String source;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  @HiveField(9)
  final bool isSynced;

  MeasurementProfileModel({
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

  /// Convert from domain entity
  factory MeasurementProfileModel.fromEntity(MeasurementProfile profile) {
    return MeasurementProfileModel(
      id: profile.id,
      userId: profile.userId,
      name: profile.name,
      height: profile.height,
      weight: profile.weight,
      measurements: profile.measurements.map(
        (key, value) => MapEntry(key, BodyMeasurementModel.fromEntity(value)),
      ),
      source: profile.source.name,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
      isSynced: profile.isSynced,
    );
  }

  /// Convert from JSON
  factory MeasurementProfileModel.fromJson(Map<String, dynamic> json) {
    final measurementsJson = json['measurements'] as Map<String, dynamic>;
    return MeasurementProfileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      measurements: measurementsJson.map(
        (key, value) => MapEntry(
          key,
          BodyMeasurementModel.fromJson(value as Map<String, dynamic>),
        ),
      ),
      source: json['source'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isSynced: json['is_synced'] as bool? ?? true,
    );
  }

  /// Convert to domain entity
  MeasurementProfile toEntity() {
    return MeasurementProfile(
      id: id,
      userId: userId,
      name: name,
      height: height,
      weight: weight,
      measurements: measurements.map(
        (key, value) => MapEntry(key, value.toEntity()),
      ),
      source: MeasurementSource.values.firstWhere(
        (s) => s.name == source,
        orElse: () => MeasurementSource.manual,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'height': height,
      'weight': weight,
      'measurements': measurements.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'source': source,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }
}

@HiveType(typeId: 2)
class BodyMeasurementModel {
  @HiveField(0)
  final String bodyPart;

  @HiveField(1)
  final double value;

  @HiveField(2)
  final double? confidence;

  @HiveField(3)
  final DateTime measuredAt;

  @HiveField(4)
  final bool isManuallyEdited;

  BodyMeasurementModel({
    required this.bodyPart,
    required this.value,
    this.confidence,
    required this.measuredAt,
    this.isManuallyEdited = false,
  });

  factory BodyMeasurementModel.fromEntity(BodyMeasurement measurement) {
    return BodyMeasurementModel(
      bodyPart: measurement.bodyPart,
      value: measurement.value,
      confidence: measurement.confidence,
      measuredAt: measurement.measuredAt,
      isManuallyEdited: measurement.isManuallyEdited,
    );
  }

  factory BodyMeasurementModel.fromJson(Map<String, dynamic> json) {
    return BodyMeasurementModel(
      bodyPart: json['body_part'] as String,
      value: (json['value'] as num).toDouble(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      measuredAt: DateTime.parse(json['measured_at'] as String),
      isManuallyEdited: json['is_manually_edited'] as bool? ?? false,
    );
  }

  BodyMeasurement toEntity() {
    return BodyMeasurement(
      bodyPart: bodyPart,
      value: value,
      confidence: confidence,
      measuredAt: measuredAt,
      isManuallyEdited: isManuallyEdited,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body_part': bodyPart,
      'value': value,
      'confidence': confidence,
      'measured_at': measuredAt.toIso8601String(),
      'is_manually_edited': isManuallyEdited,
    };
  }
}

