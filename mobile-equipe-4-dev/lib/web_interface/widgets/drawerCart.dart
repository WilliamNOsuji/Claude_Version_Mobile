import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dto/auth.dart';
import '../../models/colors.dart';
import '../../pages/paymentProcessPages/checkout_page.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class LeTiroir extends StatefulWidget {
  const LeTiroir({
    super.key,
  });

  @override
  State<LeTiroir> createState() => LeTiroirState();
}

List<CartProductDTO> listeCartProducts = [];

class LeTiroirState extends State<LeTiroir> {
  @override
  void initState() {
    // TODO: implement initState
    fetchCartProducts();
    super.initState();
  }

  Future<void> fetchCartProducts() async {
    try {
      var token = AuthService.getToken();
      List<CartProductDTO> response =
          await ApiService().getCartProducts(token, ApiService.clientId);
      setState(() {
        listeCartProducts = response;
      });
    } catch (Exception) {}
  }

  boutonDiminuer(CartProductDTO item) async {
    if (item.quantity == 1) {
      await ApiService()
          .deleteCartProducts(context, item.productId, ApiService.clientId);
      setState(() {
        listeCartProducts.remove(item);
        ApiService.CartItemCount--;
      });
    } else {
      await ApiService().decreaseQuantityCartProducts(
          context, item.productId, ApiService.clientId);
      setState(() {
        item.quantity--; // Decrease the quantity locally and trigger rebuild
        item.isOutofBound = item.quantity > item.maxQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'PANIER',
                    style: TextStyle(color: Colors.black),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.dangerous_outlined))
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: listeCartProducts.length == 0
                  ? Center(
                      child: Text(
                        "Your cart is empty!",
                        style:
                            TextStyle(fontSize: 18, color: AppColors().gray()),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: listeCartProducts.length,
                        itemBuilder: (context, index) {
                          final item = listeCartProducts[index];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.contain,
                                          height: 90,
                                          width: 90,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF040926),
                                          ),
                                        ),
                                        Text(
                                          '\$${ApiService().calculateSubTotal(item).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors().green(),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        item.isOutofBound && !item.isOutofStock
                                            ? Text(
                                                'Max : ${item.maxQuantity}',
                                                style: TextStyle(
                                                    color: AppColors().red(),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : SizedBox(),
                                        !item.isOutofStock
                                            ? Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                        item.quantity == 1
                                                            ? Icons
                                                                .delete_outline
                                                            : Icons.remove,
                                                        color:
                                                            AppColors().red()),
                                                    onPressed: () {
                                                      // Decrease quantity logic
                                                      boutonDiminuer(item);
                                                    },
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      item.quantity.toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  if (item.quantity <
                                                      item.maxQuantity) // Conditionally render the plus button
                                                    IconButton(
                                                      icon: Icon(Icons.add,
                                                          color: AppColors()
                                                              .green()),
                                                      onPressed: () async {
                                                        // Increase quantity logic
                                                        await ApiService()
                                                            .addQuantityCartProducts(
                                                                context,
                                                                item.productId,
                                                                ApiService
                                                                    .clientId);
                                                        setState(() {
                                                          item.quantity++; // Increase the quantity locally and trigger rebuild
                                                          item.isOutofBound = item
                                                                  .quantity >
                                                              item.maxQuantity;
                                                        });
                                                      },
                                                    ),
                                                ],
                                              )
                                            : Expanded(
                                                child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .redAccent.shade100,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    child: Text(
                                                      'Épuisé',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors().gray(),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '\$${ApiService().calculateFinalTotal(listeCartProducts).toStringAsFixed(2)}', // Display totalAmount
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var response = await ApiService()
                            .validateCartProducts(context, listeCartProducts);

                        if (response.toString() == "Le panier est valide") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                      listCartProducts: listeCartProducts)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.toString())));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors().black(),
                      ),
                      child: Text(
                        "Payer",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
