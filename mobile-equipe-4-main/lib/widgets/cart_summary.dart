import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/pages/order_success_page.dart';

import '../models/cart_item.dart';
import '../pages/checkout_page.dart';

// Sample cart items
final List<CartItem> cartItems = [
  CartItem(
    name: 'Item 1',
    imageUrl: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
    price: 19.99,
    quantity: 1,
  ),
  CartItem(
    name: 'Item 2',
    imageUrl: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
    price: 14.99,
    quantity: 2,
  ),
  CartItem(
    name: 'Item 3',
    imageUrl: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
    price: 29.99,
    quantity: 1,
  ),
];

class CartSummary extends StatelessWidget {
  const CartSummary({super.key,  required this.buttonText});
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Checkout logic here
                // Navigate to CheckoutPage
                if( buttonText =="Paiement"){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessPage(),
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color(0xFF353535),
              ),
              child:  Text(
                buttonText,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}