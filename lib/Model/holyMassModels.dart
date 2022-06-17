import 'package:json_annotation/json_annotation.dart';
part 'holyMassModels.g.dart';

@JsonSerializable()
class HolyMassModels {
  int seats;
  int remaining;
  String lang;
  String date;
  String time;
  HolyMassModels({
    this.lang,
    this.seats,
    this.remaining,
    this.date,
    this.time,
  });

  factory HolyMassModels.fromJson(Map<String, dynamic> json) =>
      _$HolyMassModelsFromJson(json);
  Map<String, dynamic> toJson() => _$HolyMassModelsToJson(this);
}
//@jsonkey is used to metion the _id because method not support _variable
