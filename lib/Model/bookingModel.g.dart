// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return BookingModel(
    belivers: json['belivers'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'belivers': instance.belivers,
      'phone': instance.phone,
    };
