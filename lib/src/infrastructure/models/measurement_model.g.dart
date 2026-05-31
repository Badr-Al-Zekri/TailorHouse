// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeasurementValueModelAdapter extends TypeAdapter<MeasurementValueModel> {
  @override
  final int typeId = 2;

  @override
  MeasurementValueModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeasurementValueModel(
      valueInCm: fields[0] as double,
      sourceIndex: fields[1] as int,
      confidence: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, MeasurementValueModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.valueInCm)
      ..writeByte(1)
      ..write(obj.sourceIndex)
      ..writeByte(2)
      ..write(obj.confidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementValueModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeasurementModelAdapter extends TypeAdapter<MeasurementModel> {
  @override
  final int typeId = 3;

  @override
  MeasurementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeasurementModel(
      id: fields[0] as String,
      orderId: fields[1] as String,
      height: fields[2] as MeasurementValueModel?,
      shoulder: fields[3] as MeasurementValueModel?,
      chest: fields[4] as MeasurementValueModel?,
      waist: fields[5] as MeasurementValueModel?,
      hips: fields[6] as MeasurementValueModel?,
      sleeveLength: fields[7] as MeasurementValueModel?,
      trouserLength: fields[8] as MeasurementValueModel?,
      thobeLength: fields[9] as MeasurementValueModel?,
      neck: fields[10] as MeasurementValueModel?,
      armLength: fields[11] as MeasurementValueModel?,
      wrist: fields[12] as MeasurementValueModel?,
      inseam: fields[13] as MeasurementValueModel?,
      customMeasurements:
          (fields[14] as Map).cast<String, MeasurementValueModel>(),
      imagePaths: (fields[15] as List).cast<String>(),
      measuredAt: fields[16] as DateTime,
      measuredBy: fields[17] as String,
      notes: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MeasurementModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.shoulder)
      ..writeByte(4)
      ..write(obj.chest)
      ..writeByte(5)
      ..write(obj.waist)
      ..writeByte(6)
      ..write(obj.hips)
      ..writeByte(7)
      ..write(obj.sleeveLength)
      ..writeByte(8)
      ..write(obj.trouserLength)
      ..writeByte(9)
      ..write(obj.thobeLength)
      ..writeByte(10)
      ..write(obj.neck)
      ..writeByte(11)
      ..write(obj.armLength)
      ..writeByte(12)
      ..write(obj.wrist)
      ..writeByte(13)
      ..write(obj.inseam)
      ..writeByte(14)
      ..write(obj.customMeasurements)
      ..writeByte(15)
      ..write(obj.imagePaths)
      ..writeByte(16)
      ..write(obj.measuredAt)
      ..writeByte(17)
      ..write(obj.measuredBy)
      ..writeByte(18)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
