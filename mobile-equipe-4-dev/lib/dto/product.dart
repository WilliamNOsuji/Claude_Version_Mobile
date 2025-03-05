import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
///
/// Command: flutter pub run build_runner build
part 'product.g.dart';

@JsonSerializable()
class Product{
  Product(this.id,this.name,this.quantity,this.description,this.brand,this.retailPrice,this.sellingPrice,
      this.categoryId,this.photo, this.commandProducts, this.cartProducts, this.category, this.isDeleted);

  int id;
  String name;
  int quantity;
  String description;
  String? brand;
  double? retailPrice;
  double sellingPrice;
  int? categoryId;
  String? photo;
  List<CommandProduct> commandProducts;
  List<CartProducts> cartProducts;
  Category category;
  bool isDeleted;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class CartProducts{
  CartProducts(this.cartId,this.productId,this.quantity);

  int cartId;
  int productId;
  int quantity;

  factory CartProducts.fromJson(Map<String, dynamic> json) => _$CartProductsFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductsToJson(this);
}

@JsonSerializable()
class Category{
  Category(this.id,this.name);

  int id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}


@JsonSerializable()
class CommandProduct{
  CommandProduct(this.commandId,this.productId,this.quantity);

  int commandId;
  int productId;
  int quantity;

  factory CommandProduct.fromJson(Map<String, dynamic> json) => _$CommandProductFromJson(json);

  Map<String, dynamic> toJson() => _$CommandProductToJson(this);
}
