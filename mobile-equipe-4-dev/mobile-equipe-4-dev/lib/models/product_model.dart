
import 'cartproducts_model.dart';
import 'commandproduct_model.dart';
import 'category_model.dart';

class Product {
  final int id;
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

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.description,
    this.brand,
    this.retailPrice,
    required this.sellingPrice,
    this.categoryId,
    this.photo,
    required this.commandProducts,
    required this.cartProducts,
    required this.category,
    required this.isDeleted,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      description: json['description'],
      brand: json['brand'],
      retailPrice: json['retailPrice'].toDouble(),
      sellingPrice: json['sellingPrice'].toDouble(),
      categoryId: json['categoryId'],
      photo: json['photo'],
      isDeleted: json['isDeleted'] as bool,
      commandProducts: (json['commandProducts'] as List)
          .map((cp) => CommandProduct.fromJson(cp))
          .toList(),
      cartProducts: (json['cartProducts'] as List)
          .map((cp) => CartProducts.fromJson(cp))
          .toList(),
      category: Category.fromJson(json['category']),
    );
  }

  // Convert a Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'description': description,
      'brand': brand,
      'retailPrice': retailPrice,
      'sellingPrice': sellingPrice,
      'categoryId': categoryId,
      'photo': photo,
      'commandProducts': commandProducts.map((cp) => cp.toJson()).toList(),
      'cartProducts': cartProducts.map((cp) => cp.toJson()).toList(),
      'category': category.toJson(),
      'isDeleted' : isDeleted,
    };
  }

  // Check if the product is available
  bool isAvailable() {
    return quantity > 0;
  }

  // Increase the product quantity
  Product increaseQuantity(int quantityAdded) {
    return Product(
      id: id,
      name: name,
      quantity: quantity + quantityAdded,
      description: description,
      brand: brand,
      retailPrice: retailPrice,
      sellingPrice: sellingPrice,
      categoryId: categoryId,
      photo: photo,
      commandProducts: commandProducts,
      cartProducts: cartProducts,
      category: category,
      isDeleted: isDeleted,
    );
  }

  // Decrease the product quantity
  Product decreaseQuantity(int quantityRemoved) {
    return Product(
      id: id,
      name: name,
      quantity: quantity - quantityRemoved,
      description: description,
      brand: brand,
      retailPrice: retailPrice,
      sellingPrice: sellingPrice,
      categoryId: categoryId,
      photo: photo,
      commandProducts: commandProducts,
      cartProducts: cartProducts,
      category: category,
      isDeleted : isDeleted,
    );
  }

  // Set the selling price and update discount status
  Product setPrice(double newPrice) {
    return Product(
      id: id,
      name: name,
      quantity: quantity,
      description: description,
      brand: brand,
      retailPrice: retailPrice,
      sellingPrice: newPrice,
      categoryId: categoryId,
      photo: photo,
      commandProducts: commandProducts,
      cartProducts: cartProducts,
      category: category,
      isDeleted: isDeleted,
    );
  }
}