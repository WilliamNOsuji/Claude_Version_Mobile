class CommandProduct {
  final int id;
  final int productId;
  final int commandId;
  final int quantity;

  CommandProduct({
    required this.id,
    required this.productId,
    required this.commandId,
    required this.quantity,
  });

  // Factory method to create a CommandProduct from JSON
  factory CommandProduct.fromJson(Map<String, dynamic> json) {
    return CommandProduct(
      id: json['id'],
      productId: json['productId'],
      commandId: json['commandId'],
      quantity: json['quantity'],
    );
  }

  // Convert a CommandProduct to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'commandId': commandId,
      'quantity': quantity,
    };
  }
}