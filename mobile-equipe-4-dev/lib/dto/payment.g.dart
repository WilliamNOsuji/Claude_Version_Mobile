// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentIntentDTO _$PaymentIntentDTOFromJson(Map<String, dynamic> json) =>
    PaymentIntentDTO(
      json['clientSecret'] as String,
      json['customer'] as String,
    );

Map<String, dynamic> _$PaymentIntentDTOToJson(PaymentIntentDTO instance) =>
    <String, dynamic>{
      'clientSecret': instance.clientSecret,
      'customer': instance.customer,
    };

CustomerDTO _$CustomerDTOFromJson(Map<String, dynamic> json) => CustomerDTO(
      json['email'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
    );

Map<String, dynamic> _$CustomerDTOToJson(CustomerDTO instance) =>
    <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

PaymentInfoDTO _$PaymentInfoDTOFromJson(Map<String, dynamic> json) =>
    PaymentInfoDTO(
      (json['amount'] as num).toDouble(),
      json['cardNumber'] as String,
      (json['cvcNumber'] as num).toInt(),
      DateTime.parse(json['expirationDate'] as String),
    );

Map<String, dynamic> _$PaymentInfoDTOToJson(PaymentInfoDTO instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'cardNumber': instance.cardNumber,
      'cvcNumber': instance.cvcNumber,
      'expirationDate': instance.expirationDate.toIso8601String(),
    };

CommandDTO _$CommandDTOFromJson(Map<String, dynamic> json) => CommandDTO(
      json['address'] as String,
      json['currency'] as String,
      (json['totalPrice'] as num).toDouble(),
      json['phoneNumber'] as String,
      (json['deviceTokens'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CommandDTOToJson(CommandDTO instance) =>
    <String, dynamic>{
      'totalPrice': instance.totalPrice,
      'currency': instance.currency,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'deviceTokens': instance.deviceTokens,
    };

DeliveryManDTO _$DeliveryManDTOFromJson(Map<String, dynamic> json) =>
    DeliveryManDTO(
      json['username'] as String,
      json['fullName'] as String,
    );

Map<String, dynamic> _$DeliveryManDTOToJson(DeliveryManDTO instance) =>
    <String, dynamic>{
      'username': instance.username,
      'fullName': instance.fullName,
    };

CheckoutSessionRequest _$CheckoutSessionRequestFromJson(
        Map<String, dynamic> json) =>
    CheckoutSessionRequest(
      (json['totalPrice'] as num).toDouble(),
      json['currency'] as String,
      json['address'] as String,
      json['phoneNum'] as String,
      (json['deviceTokens'] as List<dynamic>).map((e) => e as String).toList(),
      json['successUrl'] as String,
      json['cancelUrl'] as String,
    );

Map<String, dynamic> _$CheckoutSessionRequestToJson(
        CheckoutSessionRequest instance) =>
    <String, dynamic>{
      'totalPrice': instance.totalPrice,
      'currency': instance.currency,
      'address': instance.address,
      'phoneNum': instance.phoneNum,
      'deviceTokens': instance.deviceTokens,
      'successUrl': instance.successUrl,
      'cancelUrl': instance.cancelUrl,
    };

Command _$CommandFromJson(Map<String, dynamic> json) => Command(
      (json['id'] as num).toInt(),
      (json['commandNumber'] as num).toInt(),
      json['clientPhoneNumber'] as String,
      json['arrivalPoint'] as String,
      (json['totalPrice'] as num).toDouble(),
      json['currency'] as String,
      json['isDelivered'] as bool,
      json['isInProgress'] as bool,
      (json['clientId'] as num).toInt(),
      (json['deliveryManId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CommandToJson(Command instance) => <String, dynamic>{
      'id': instance.id,
      'commandNumber': instance.commandNumber,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'arrivalPoint': instance.arrivalPoint,
      'totalPrice': instance.totalPrice,
      'currency': instance.currency,
      'isDelivered': instance.isDelivered,
      'isInProgress': instance.isInProgress,
      'clientId': instance.clientId,
      'deliveryManId': instance.deliveryManId,
    };
