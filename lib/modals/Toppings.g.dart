// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Toppings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToppingsAdapter extends TypeAdapter<Toppings> {
  @override
  final int typeId = 3;

  @override
  Toppings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Toppings(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Toppings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.top_cat_id)
      ..writeByte(2)
      ..write(obj.toppingName)
      ..writeByte(3)
      ..write(obj.toppingPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToppingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
