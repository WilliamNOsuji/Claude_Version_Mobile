import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/services/api_service.dart';

class CartItemTile extends StatefulWidget {
  final CartProductDTO item;

  const CartItemTile({super.key, required this.item});

  @override
  _CartItemTileState createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  late CartProductDTO item;

  @override
  void initState() {
    super.initState();
    item = widget.item; // Initialize item with the data passed from the parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                height: 80,
                width: 80,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${ApiService().calculateSubTotal(item).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: () async {
                    // Decrease quantity logic
                    await ApiService().decreaseQuantityCartProducts(context, item.productId, ApiService.clientId);
                    setState(() {
                      item.quantity--; // Decrease the quantity locally and trigger rebuild
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.quantity.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () async {
                    // Increase quantity logic
                    await ApiService().addQuantityCartProducts(context, item.productId, ApiService.clientId);
                    setState(() {
                      item.quantity++; // Increase the quantity locally and trigger rebuild
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {}, // Trigger onRemove callback
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
