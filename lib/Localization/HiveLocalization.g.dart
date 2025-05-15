// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveLocalization.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLocalizationAdapter extends TypeAdapter<HiveLocalization> {
  @override
  final int typeId = 0;

  @override
  HiveLocalization read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLocalization(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveLocalization obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.countryCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLocalizationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
