// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paymentListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentListModel _$PaymentListModelFromJson(Map<String, dynamic> json) {
  return PaymentListModel(
    payments: (json['payments'] as List)
        ?.map((e) =>
            e == null ? null : PaymentModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PaymentListModelToJson(PaymentListModel instance) =>
    <String, dynamic>{
      'payments': instance.payments,
    };
