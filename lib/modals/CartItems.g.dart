// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CartItems.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartITemsAdapter extends TypeAdapter<CartITems> {
  @override
  final int typeId = 1;

  @override
  CartITems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartITems()
      ..itemQty = fields[0] as String
      ..itemName = fields[1] as String
      ..itemTotalPrice = fields[2] as String
      ..image = fields[3] as String
      ..toppings = (fields[4] as List)?.cast<Toppings>()
      ..itemAmt = fields[5] as String
      ..itemId = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, CartITems obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.itemQty)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.itemTotalPrice)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.toppings)
      ..writeByte(5)
      ..write(obj.itemAmt)
      ..writeByte(6)
      ..write(obj.itemId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartITemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
