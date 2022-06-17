import 'package:json_annotation/json_annotation.dart';
import './paymentModel.dart';

part 'paymentListModel.g.dart';

@JsonSerializable()
class PaymentListModel {
  List<PaymentModel> payments;
  PaymentListModel({this.payments});
  factory PaymentListModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentListModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentListModelToJson(this);
}
