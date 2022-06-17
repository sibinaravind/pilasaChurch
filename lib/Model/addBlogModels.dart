import 'package:json_annotation/json_annotation.dart';
part 'addBlogModels.g.dart';

@JsonSerializable()
class AddBlogModel {
  String color;
  String content;
  DateTime created;
  @JsonKey(name: "_id")
  String id;
  AddBlogModel({
    this.color,
    this.content,
    this.created,
    this.id,
  });
  factory AddBlogModel.fromJson(Map<String, dynamic> json) =>
      _$AddBlogModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddBlogModelToJson(this);
}
//@jsonkey is used to metion the _id because method not support _variable
