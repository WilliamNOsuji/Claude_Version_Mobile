import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/widgets/order_progress.dart';

import '../widgets/bottom_nav.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';
import '../widgets/custom_app_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}
class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(
        title: 'Cart',
        centerTitle: true,
      ),
      bottomNavigationBar: navigationBar(context, 1, setState),
      body: Column(
        children: [
          Divider(
            color: Color(0xFFCFCFCF),
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: OrderProgress(activeStep: 1,),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemTile(item: item);
              },
            ),
          ),
          const CartSummary( buttonText:  "Checkout",),
        ],
      ),
    );
  }
}

