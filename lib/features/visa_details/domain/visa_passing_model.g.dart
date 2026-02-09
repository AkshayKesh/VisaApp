// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_passing_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisaApplicationModelAdapter extends TypeAdapter<VisaApplicationModel> {
  @override
  final int typeId = 1;

  @override
  VisaApplicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisaApplicationModel(
      id: fields[0] as String?,
      visaType: fields[1] as String?,
      lengthOfStay: fields[2] as int?,
      visaValidity: fields[3] as int?,
      country: fields[4] as String?,
      entryType: fields[7] as String?,
      visaFee: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, VisaApplicationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.visaType)
      ..writeByte(2)
      ..write(obj.lengthOfStay)
      ..writeByte(3)
      ..write(obj.visaValidity)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.visaFee)
      ..writeByte(7)
      ..write(obj.entryType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisaApplicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
