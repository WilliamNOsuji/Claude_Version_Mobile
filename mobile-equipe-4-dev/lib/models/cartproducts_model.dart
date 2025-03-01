class CartProducts {
  int id;
  int cartId;
  int productId;
  int quantity;

  CartProducts({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  // Factory method to create a CartProducts from JSON
  factory CartProducts.fromJson(Map<String, dynamic> json) {
    return CartProducts(
      id: json['id'],
      cartId: json['cartId'],
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }

  // Convert a CartProducts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
    };
  }
}