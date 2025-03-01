// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigninDTO _$SigninDTOFromJson(Map<String, dynamic> json) => SigninDTO(
      json['username'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$SigninDTOToJson(SigninDTO instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

SigninSuccessDTO _$SigninSuccessDTOFromJson(Map<String, dynamic> json) =>
    SigninSuccessDTO(
      json['token'] as String,
      (json['clientId'] as num).toInt(),
      json['clientName'] as String,
      json['isDeliveryMan'] as bool,
      json['isActive'] as bool,
    );

Map<String, dynamic> _$SigninSuccessDTOToJson(SigninSuccessDTO instance) =>
    <String, dynamic>{
      'token': instance.token,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'isDeliveryMan': instance.isDeliveryMan,
      'isActive': instance.isActive,
    };

RegisterDTO _$RegisterDTOFromJson(Map<String, dynamic> json) => RegisterDTO(
      json['username'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['email'] as String,
      json['password'] as String,
      json['passwordConfirm'] as String,
    );

Map<String, dynamic> _$RegisterDTOToJson(RegisterDTO instance) =>
    <String, dynamic>{
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'passwordConfirm': instance.passwordConfirm,
    };

CartProductDTO _$CartProductDTOFromJson(Map<String, dynamic> json) =>
    CartProductDTO(
      (json['id'] as num).toInt(),
      (json['cartId'] as num).toInt(),
      (json['productId'] as num).toInt(),
      (json['quantity'] as num).toInt(),
      json['name'] as String,
      (json['prix'] as num).toDouble(),
      json['imageUrl'] as String,
      (json['maxQuantity'] as num).toInt(),
      json['isOutofStock'] as bool,
      json['isOutofBound'] as bool,
    );

Map<String, dynamic> _$CartProductDTOToJson(CartProductDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cartId': instance.cartId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'name': instance.name,
      'prix': instance.prix,
      'imageUrl': instance.imageUrl,
      'maxQuantity': instance.maxQuantity,
      'isOutofStock': instance.isOutofStock,
      'isOutofBound': instance.isOutofBound,
    };

ProfileDTO _$ProfileDTOFromJson(Map<String, dynamic> json) => ProfileDTO(
      json['userName'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['imgUrl'] as String,
      json['isDeliveryMan'] as bool,
      json['isActiveAsDeliveryMan'] as bool,
    );

Map<String, dynamic> _$ProfileDTOToJson(ProfileDTO instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'imgUrl': instance.imgUrl,
      'isDeliveryMan': instance.isDeliveryMan,
      'isActiveAsDeliveryMan': instance.isActiveAsDeliveryMan,
    };

ProfileModificationDTO _$ProfileModificationDTOFromJson(
        Map<String, dynamic> json) =>
    ProfileModificationDTO(
      json['newFirstName'] as String?,
      json['newLastName'] as String?,
      json['newPassword'] as String?,
      json['oldPassword'] as String?,
    );

Map<String, dynamic> _$ProfileModificationDTOToJson(
        ProfileModificationDTO instance) =>
    <String, dynamic>{
      'newFirstName': instance.newFirstName,
      'newLastName': instance.newLastName,
      'newPassword': instance.newPassword,
      'oldPassword': instance.oldPassword,
    };
