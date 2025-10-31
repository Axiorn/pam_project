// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmi_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BmiResultModelAdapter extends TypeAdapter<BmiResultModel> {
  @override
  final int typeId = 1;

  @override
  BmiResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BmiResultModel(
      weight: fields[0] as double,
      height: fields[1] as double,
      bmi: fields[2] as double,
      category: fields[3] as String,
      dateTime: fields[4] as String,
      location: fields[5] as String,
      username: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BmiResultModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.bmi)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.username);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BmiResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
