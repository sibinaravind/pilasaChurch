import 'package:json_annotation/json_annotation.dart';
import './bookingModel.dart';

part 'bookingListModel.g.dart';

@JsonSerializable()
class BookingListModel {
  List<BookingModel> data;
  BookingListModel({this.data});
  factory BookingListModel.fromJson(Map<String, dynamic> json) =>
      _$BookingListModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingListModelToJson(this);
}
