// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['quantity'] as num).toInt(),
      json['description'] as String,
      json['brand'] as String?,
      (json['retailPrice'] as num?)?.toDouble(),
      (json['sellingPrice'] as num).toDouble(),
      (json['categoryId'] as num?)?.toInt(),
      json['photo'] as String?,
      (json['commandProducts'] as List<dynamic>)
          .map((e) => CommandProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['cartProducts'] as List<dynamic>)
          .map((e) => CartProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
      Category.fromJson(json['category'] as Map<String, dynamic>),
      json['isDeleted'] as bool,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'description': instance.description,
      'brand': instance.brand,
      'retailPrice': instance.retailPrice,
      'sellingPrice': instance.sellingPrice,
      'categoryId': instance.categoryId,
      'photo': instance.photo,
      'commandProducts': instance.commandProducts,
      'cartProducts': instance.cartProducts,
      'category': instance.category,
      'isDeleted': instance.isDeleted,
    };

CartProducts _$CartProductsFromJson(Map<String, dynamic> json) => CartProducts(
      (json['cartId'] as num).toInt(),
      (json['productId'] as num).toInt(),
      (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartProductsToJson(CartProducts instance) =>
    <String, dynamic>{
      'cartId': instance.cartId,
      'productId': instance.productId,
      'quantity': instance.quantity,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

CommandProduct _$CommandProductFromJson(Map<String, dynamic> json) =>
    CommandProduct(
      (json['commandId'] as num).toInt(),
      (json['productId'] as num).toInt(),
      (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CommandProductToJson(CommandProduct instance) =>
    <String, dynamic>{
      'commandId': instance.commandId,
      'productId': instance.productId,
      'quantity': instance.quantity,
    };
