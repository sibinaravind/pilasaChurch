import 'package:json_annotation/json_annotation.dart';
part 'bookingModel.g.dart';

@JsonSerializable()
class BookingModel {
  String belivers;
  String phone;
  BookingModel({
    this.belivers,
    this.phone,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
//@jsonkey is used to metion the _id because method not support _variable
