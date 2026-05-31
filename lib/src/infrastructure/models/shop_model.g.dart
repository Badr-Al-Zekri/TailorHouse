// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopModelAdapter extends TypeAdapter<ShopModel> {
  @override
  final int typeId = 0;

  @override
  ShopModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopModel(
      id: fields[0] as String,
      code: fields[1] as String,
      name: fields[2] as String,
      phoneNumber: fields[3] as String,
      address: fields[4] as String?,
      currency: fields[5] as String,
      createdAt: fields[6] as DateTime,
      yearlySequences: (fields[7] as Map).cast<int, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.yearlySequences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
