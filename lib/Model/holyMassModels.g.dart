// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holyMassModels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HolyMassModels _$HolyMassModelsFromJson(Map<String, dynamic> json) {
  return HolyMassModels(
    lang: json['lang'] as String,
    seats: json['seats'] as int,
    remaining: json['remaining'] as int,
    date: json['date'] as String,
    time: json['time'] as String,
  );
}

Map<String, dynamic> _$HolyMassModelsToJson(HolyMassModels instance) =>
    <String, dynamic>{
      'seats': instance.seats,
      'remaining': instance.remaining,
      'lang': instance.lang,
      'date': instance.date,
      'time': instance.time,
    };
