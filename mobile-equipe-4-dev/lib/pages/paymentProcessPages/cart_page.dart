// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../widgets/order_progress.dart';
import '../../widgets/cartRelated/cart_item_tile.dart';
import '../../widgets/custom_app_bar.dart';
import 'checkout_page.dart';



class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.CardProducts});
  final List<CartProductDTO> CardProducts;


  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      ApiService.CartItemCount = widget.CardProducts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).panier,
        centerTitle: true,
        backPage: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Divider(
            color: Color(0xFFCFCFCF),
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: OrderProgress(activeStep: 1),
          ),
          Expanded(
            child: widget.CardProducts.length ==0
                ? buildEmptyCard()
                : ListView.builder(
              itemCount: widget.CardProducts.length,
              itemBuilder: (context, index) {
                final item = widget.CardProducts[index];
                return buildCard(item, context);
              },
            ),
          ),
          buildBottomPay(context)
        ],
      ),
    );
  }




  Container buildBottomPay(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(S.of(context).subtotal, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                '\$${ApiService().calculateFinalTotal(widget.CardProducts).toStringAsFixed(2)}', // Display totalAmount
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if(widget.CardProducts.length>0){
                  var response = await ApiService().validateCartProducts(context, widget.CardProducts);

                  if(response.toString() == "Le panier est valide"){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CheckoutPage(listCartProducts: widget.CardProducts,))
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response.toString())));
                  }
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.of(context).lePanierEstVide)));
                }


              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors().black(),
              ),
              child: Text(
                S.of(context).payer,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center buildEmptyCard() {
    return Center(
      child: Text(
        S.of(context).yourCartIsEmpty,
        style: TextStyle(fontSize: 18, color: AppColors().gray()),
      ),
    );
  }

  Card buildCard(CartProductDTO item, BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors().black()
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${ApiService().calculateSubTotal(item).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color:AppColors().green(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      item.quantity == item.maxQuantity? Text(S.of(context).max + item.maxQuantity.toString(), style: TextStyle(color: AppColors().red(), fontWeight: FontWeight.bold),) : SizedBox()
                    ],
                  ),

                ],
              ),
            ),
            !item.isOutofStock ? Row(
              children: [
                IconButton(
                  icon: Icon(
                      item.quantity >1
                          ? Icons.remove
                          : Icons.disabled_by_default,
                      color: AppColors().red()),
                  onPressed: () {
                    // Decrease quantity logic
                    item.quantity>1 ?
                    boutonDiminuer(item):null;
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.quantity.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(
                      item.quantity < item.maxQuantity?
                      Icons.add:
                      Icons.disabled_by_default, color: AppColors().green()),
                  onPressed: () async {
                    // Increase quantity logic
                    await buttonAdd(item, context);

                  },
                ),
              ],
            ) :
            Expanded(child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.redAccent.shade100,
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Text(S.of(context).puis, style: TextStyle(color: Colors.white),))
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AppColors().red()),
              onPressed: () async{
                await ApiService().deleteCartProducts(context, item.productId, ApiService.clientId);
                setState(() {
                  widget.CardProducts.remove(item);
                  ApiService.CartItemCount--;
                });
              }, // Trigger onRemove callback
            ),
          ],
        ),
      ),
    );
  }

  Future<void> buttonAdd(CartProductDTO item, BuildContext context) async {
    if(!item.isOutofBound){
      await ApiService().addQuantityCartProducts(
          context,
          item.productId,
          ApiService.clientId);
      if(item.quantity < item.maxQuantity){
        setState(() {
          item.quantity++; // Increase the quantity locally and trigger rebuild
          item.isOutofBound = item.quantity > item.maxQuantity;
        });
      }

    }
  }

  boutonDiminuer(CartProductDTO item) async{
    if(item.quantity <= 1){
      try{
        await ApiService().deleteCartProducts(context, item.productId, ApiService.clientId);
        setState(() {
          widget.CardProducts.remove(item);
          ApiService.CartItemCount--;
        });
      }
      catch (Exception ){

      }

    }else {
      try{
        await ApiService().decreaseQuantityCartProducts(context, item.productId, ApiService.clientId);
        if(item.quantity >1){
          setState(() {
            item.quantity--; // Decrease the quantity locally and trigger rebuild
            item.isOutofBound = item.quantity > item.maxQuantity;
          });
        }

      }catch(Exception){

      }

    }
  }
}
