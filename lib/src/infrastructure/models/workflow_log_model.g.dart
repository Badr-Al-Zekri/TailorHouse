// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkflowLogModelAdapter extends TypeAdapter<WorkflowLogModel> {
  @override
  final int typeId = 4;

  @override
  WorkflowLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkflowLogModel(
      id: fields[0] as String,
      orderId: fields[1] as String,
      fromStatusIndex: fields[2] as int?,
      toStatusIndex: fields[3] as int,
      userId: fields[4] as String,
      userName: fields[5] as String,
      userRole: fields[6] as String,
      timestamp: fields[7] as DateTime,
      notes: fields[8] as String?,
      deviceInfo: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkflowLogModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.fromStatusIndex)
      ..writeByte(3)
      ..write(obj.toStatusIndex)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.userName)
      ..writeByte(6)
      ..write(obj.userRole)
      ..writeByte(7)
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.deviceInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkflowLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
