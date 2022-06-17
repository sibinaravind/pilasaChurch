// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'massListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MassListModel _$MassListModelFromJson(Map<String, dynamic> json) {
  return MassListModel(
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : HolyMassModels.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MassListModelToJson(MassListModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
