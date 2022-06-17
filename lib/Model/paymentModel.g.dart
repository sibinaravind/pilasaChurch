// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paymentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return PaymentModel(
    amt: json['amt'] as int,
    date: json['date'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    payId: json['pay_id'] as String,
  );
}

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'amt': instance.amt,
      'date': instance.date,
      'name': instance.name,
      'type': instance.type,
      'pay_id': instance.payId,
    };
