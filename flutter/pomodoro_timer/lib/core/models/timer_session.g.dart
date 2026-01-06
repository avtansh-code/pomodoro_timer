// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerSessionAdapter extends TypeAdapter<TimerSession> {
  @override
  final int typeId = 0;

  @override
  TimerSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerSession(
      id: fields[0] as String,
      sessionType: fields[1] as SessionType,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      durationInMinutes: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimerSession obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sessionType)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.durationInMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
