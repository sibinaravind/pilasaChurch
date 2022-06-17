import 'package:json_annotation/json_annotation.dart';
import './holyMassModels.dart';

part 'massListModel.g.dart';

@JsonSerializable()
class MassListModel {
  List<HolyMassModels> data;
  MassListModel({this.data});
  factory MassListModel.fromJson(Map<String, dynamic> json) =>
      _$MassListModelFromJson(json);
  Map<String, dynamic> toJson() => _$MassListModelToJson(this);
}
