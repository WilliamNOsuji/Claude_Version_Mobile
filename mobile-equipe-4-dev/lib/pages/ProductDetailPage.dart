import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_product_detail_page.dart';
import '../dto/product.dart';
import '../generated/l10n.dart';
import '../services/api_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key,required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        //title: Text(product.name),
        backgroundColor: AppColors().white(),
      ),
      backgroundColor: AppColors().white(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: widget.product.photo != null
                  ? Image.network(widget.product.photo!, fit: BoxFit.cover)
                  : Image.asset('assets/images/placeholder_image.webp', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors().green()),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(fontSize: 16, color: AppColors().gray()),
                  ),
                  SizedBox(height: 16),
                  Text(
                    S.of(context).brand +widget.product.brand.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quantity: ' + widget.product.quantity.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  widget.product.quantity > 0 ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().green(),
                        foregroundColor: AppColors().white()
                    ),
                    onPressed: () async {
                      try{
                        var response = await ApiService().addCartProducts(context,widget.product.id,ApiService.clientId,setState,);
                        if (response == "Ce produit n'existe plus" || response == "Ce produit est épuisé") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
                        }
                      }finally{
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(S.of(context).addToCart, style: TextStyle(fontWeight: FontWeight.bold),),
                  ) : SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
