import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';
import '../../models/product_model.dart';
import '../../services/api_service.dart';

class WebProductDetailPage extends StatefulWidget {
  final Product product;
  const WebProductDetailPage({super.key,required this.product});

  @override
  State<WebProductDetailPage> createState() => _WebProductDetailPageState();
}

class _WebProductDetailPageState extends State<WebProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebCustomAppBar( ),
      backgroundColor: AppColors().white(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                Text("Détail d'un produit", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Inter'),),

                Hero(
                  tag: 'product-${widget.product.id}',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 550,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.black),

                              ),
                              child: widget.product.photo != null
                                  ? Image.network(widget.product.photo!, fit: BoxFit.contain)
                                  : Image.asset('assets/images/placeholder_image.webp', fit: BoxFit.cover),
                            ),
                          ),
                      ),
                      Expanded(
                          child:
                          Container(
                            height: 550,
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.name,
                                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    widget.product.description,
                                    style: TextStyle(fontSize: 16, color: AppColors().gray()),
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    "\$ "+widget.product.sellingPrice.toString() +".00",
                                    style: TextStyle(fontSize: 50, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 40),

                                  Text(
                                    "Spécification",
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  SizedBox(height: 24),

                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Marque : ", style: TextStyle(fontSize: 16, color: AppColors().gray(), )),
                                          Text(
                                            '${widget.product.brand}',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      Row(
                                        children: [
                                          Text("Quantity : ", style: TextStyle(fontSize: 16, color: AppColors().gray(), )),
                                          Text(
                                            '${widget.product.quantity}',
                                            style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      Row(
                                        children: [
                                          Text("Catégorie : ", style: TextStyle(fontSize: 16, color: AppColors().gray(), )),
                                          Text(
                                            '${widget.product.category.name}',
                                            style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Spacer(),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [

                                      Container(
                                        height: 70,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              foregroundColor: AppColors().white()
                                          ),
                                          onPressed: () async {
                                            try{
                                              var response = await ApiService().addCartProducts(context,widget.product.id,ApiService.clientId,setState,);
                                              if (response == "Ce produit n'existe plus" || response == "Ce produit est épuisé") {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
                                              }
                                            }finally{
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => WebHomePage()));
                                            }


                                          },
                                          child: Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                      )

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
