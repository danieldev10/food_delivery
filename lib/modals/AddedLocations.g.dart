// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AddedLocations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddedLocationsAdapter extends TypeAdapter<AddedLocations> {
  @override
  final int typeId = 4;

  @override
  AddedLocations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddedLocations.constructor(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddedLocations obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.addressLine)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.long);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddedLocationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
