import 'package:json_annotation/json_annotation.dart';
part 'paymentModel.g.dart';

@JsonSerializable()
class PaymentModel {
  int amt;
  String date;
  String name;
  String type;
  @JsonKey(name: "pay_id")
  String payId;
  PaymentModel({this.amt, this.date, this.name, this.type, this.payId});

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
