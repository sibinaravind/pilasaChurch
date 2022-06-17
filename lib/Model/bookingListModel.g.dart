// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookingListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingListModel _$BookingListModelFromJson(Map<String, dynamic> json) {
  return BookingListModel(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : BookingModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BookingListModelToJson(BookingListModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
