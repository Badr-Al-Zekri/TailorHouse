import 'package:hive/hive.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'measurement_model.g.dart';

/// Hive model for MeasurementValue
@HiveType(typeId: 2)
class MeasurementValueModel {
  @HiveField(0)
  final double valueInCm;

  @HiveField(1)
  final int sourceIndex; // MeasurementSource enum index

  @HiveField(2)
  final double? confidence;

  MeasurementValueModel({
    required this.valueInCm,
    required this.sourceIndex,
    this.confidence,
  });

  factory MeasurementValueModel.fromEntity(MeasurementValue entity) {
    return MeasurementValueModel(
      valueInCm: entity.valueInCm,
      sourceIndex: entity.source.index,
      confidence: entity.confidence,
    );
  }

  MeasurementValue toEntity() {
    final source = MeasurementSource.values[sourceIndex];
    return MeasurementValue.cm(
      valueInCm,
      source: source,
      confidence: confidence,
    );
  }
}

/// Hive model for Measurement entity
@HiveType(typeId: 3)
class MeasurementModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String orderId;

  @HiveField(2)
  final MeasurementValueModel? height;

  @HiveField(3)
  final MeasurementValueModel? shoulder;

  @HiveField(4)
  final MeasurementValueModel? chest;

  @HiveField(5)
  final MeasurementValueModel? waist;

  @HiveField(6)
  final MeasurementValueModel? hips;

  @HiveField(7)
  final MeasurementValueModel? sleeveLength;

  @HiveField(8)
  final MeasurementValueModel? trouserLength;

  @HiveField(9)
  final MeasurementValueModel? thobeLength;

  @HiveField(10)
  final MeasurementValueModel? neck;

  @HiveField(11)
  final MeasurementValueModel? armLength;

  @HiveField(12)
  final MeasurementValueModel? wrist;

  @HiveField(13)
  final MeasurementValueModel? inseam;

  @HiveField(14)
  final Map<String, MeasurementValueModel> customMeasurements;

  @HiveField(15)
  final List<String> imagePaths;

  @HiveField(16)
  final DateTime measuredAt;

  @HiveField(17)
  final String measuredBy;

  @HiveField(18)
  final String? notes;

  MeasurementModel({
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
    required this.customMeasurements,
    required this.imagePaths,
    required this.measuredAt,
    required this.measuredBy,
    this.notes,
  });

  /// Convert from domain entity
  factory MeasurementModel.fromEntity(Measurement entity) {
    MeasurementValueModel? convert(MeasurementValue? value) {
      return value != null ? MeasurementValueModel.fromEntity(value) : null;
    }

    return MeasurementModel(
      id: entity.id,
      orderId: entity.orderId,
      height: convert(entity.height),
      shoulder: convert(entity.shoulder),
      chest: convert(entity.chest),
      waist: convert(entity.waist),
      hips: convert(entity.hips),
      sleeveLength: convert(entity.sleeveLength),
      trouserLength: convert(entity.trouserLength),
      thobeLength: convert(entity.thobeLength),
      neck: convert(entity.neck),
      armLength: convert(entity.armLength),
      wrist: convert(entity.wrist),
      inseam: convert(entity.inseam),
      customMeasurements: entity.customMeasurements.map(
        (key, value) => MapEntry(key, MeasurementValueModel.fromEntity(value)),
      ),
      imagePaths: List<String>.from(entity.imagePaths),
      measuredAt: entity.measuredAt,
      measuredBy: entity.measuredBy,
      notes: entity.notes,
    );
  }

  /// Convert to domain entity
  Measurement toEntity() {
    return Measurement(
      id: id,
      orderId: orderId,
      height: height?.toEntity(),
      shoulder: shoulder?.toEntity(),
      chest: chest?.toEntity(),
      waist: waist?.toEntity(),
      hips: hips?.toEntity(),
      sleeveLength: sleeveLength?.toEntity(),
      trouserLength: trouserLength?.toEntity(),
      thobeLength: thobeLength?.toEntity(),
      neck: neck?.toEntity(),
      armLength: armLength?.toEntity(),
      wrist: wrist?.toEntity(),
      inseam: inseam?.toEntity(),
      customMeasurements: customMeasurements.map(
        (key, value) => MapEntry(key, value.toEntity()),
      ),
      imagePaths: List<String>.from(imagePaths),
      measuredAt: measuredAt,
      measuredBy: measuredBy,
      notes: notes,
    );
  }
}

