// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 5;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      garmentIdString: fields[1] as String,
      shopId: fields[2] as String,
      customerId: fields[3] as String,
      customerName: fields[4] as String,
      customerPhone: fields[5] as String,
      garmentTypeIndex: fields[6] as int,
      fabricDescription: fields[7] as String,
      fabricColor: fields[8] as String?,
      totalPriceInSmallestUnit: fields[9] as int,
      depositPaidInSmallestUnit: fields[10] as int,
      currency: fields[11] as String,
      statusIndex: fields[12] as int,
      expectedDeliveryDate: fields[13] as DateTime,
      actualDeliveryDate: fields[14] as DateTime?,
      measurement: fields[15] as MeasurementModel?,
      workflowLogs: (fields[16] as List).cast<WorkflowLogModel>(),
      notes: fields[17] as String?,
      createdAt: fields[18] as DateTime,
      updatedAt: fields[19] as DateTime,
      createdBy: fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.garmentIdString)
      ..writeByte(2)
      ..write(obj.shopId)
      ..writeByte(3)
      ..write(obj.customerId)
      ..writeByte(4)
      ..write(obj.customerName)
      ..writeByte(5)
      ..write(obj.customerPhone)
      ..writeByte(6)
      ..write(obj.garmentTypeIndex)
      ..writeByte(7)
      ..write(obj.fabricDescription)
      ..writeByte(8)
      ..write(obj.fabricColor)
      ..writeByte(9)
      ..write(obj.totalPriceInSmallestUnit)
      ..writeByte(10)
      ..write(obj.depositPaidInSmallestUnit)
      ..writeByte(11)
      ..write(obj.currency)
      ..writeByte(12)
      ..write(obj.statusIndex)
      ..writeByte(13)
      ..write(obj.expectedDeliveryDate)
      ..writeByte(14)
      ..write(obj.actualDeliveryDate)
      ..writeByte(15)
      ..write(obj.measurement)
      ..writeByte(16)
      ..write(obj.workflowLogs)
      ..writeByte(17)
      ..write(obj.notes)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt)
      ..writeByte(20)
      ..write(obj.createdBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
