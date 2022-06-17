// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addBlogModels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddBlogModel _$AddBlogModelFromJson(Map<String, dynamic> json) {
  return AddBlogModel(
    color: json['color'] as String,
    content: json['content'] as String,
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    id: json['_id'] as String,
  );
}

Map<String, dynamic> _$AddBlogModelToJson(AddBlogModel instance) =>
    <String, dynamic>{
      'color': instance.color,
      'content': instance.content,
      'created': instance.created?.toIso8601String(),
      '_id': instance.id,
    };
