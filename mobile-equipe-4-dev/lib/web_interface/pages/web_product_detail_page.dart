import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/web_interface/widgets/footer.dart';
import 'package:mobilelapincouvert/web_interface/widgets/web_menu_drawer.dart';
import '../../dto/auth.dart';
import '../../dto/product.dart';
import '../../services/api_service.dart';
import '../widgets/drawerCart.dart';

class WebProductDetailPage extends StatefulWidget {
  final Product product;
  final ProfileDTO profileDTO;
  const WebProductDetailPage({super.key, required this.product, required this.profileDTO});

  @override
  State<WebProductDetailPage> createState() => _WebProductDetailPageState();
}

class _WebProductDetailPageState extends State<WebProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 1000;
    return Scaffold(
      endDrawer: LeTiroir(),
      drawer: WebMenuDrawer(profileDTO: widget.profileDTO) ,
      appBar: WebCustomAppBar(),
      backgroundColor: AppColors().white(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'produit-${widget.product.id}',
                      child: isSmallScreen
                          ? Column(
                              children: [
                                SizedBox(height: 100,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 500,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color:
                                              AppColors().gray().withOpacity(0.3),
                                          width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors().gray().withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: widget.product.photo != null
                                        ? Image.network(widget.product.photo!,
                                            fit: BoxFit.contain)
                                        : Image.asset(
                                            'assets/images/placeholder_image.webp',
                                            fit: BoxFit.cover),
                                  ),
                                ),
                                Container(
                                  height: 700,
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
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        if (widget.product.sellingPrice < 25)
                                          Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: AppColors()
                                                      .green()
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.local_offer,
                                                      color: AppColors().green(),
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "Au plus bas prix !",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors().green(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                            ],
                                          ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors().gray().withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Text(
                                            widget.product.description,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors().gray(),
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Text(
                                          "\$ " +
                                              widget.product.sellingPrice
                                                  .toString() +
                                              ".00",
                                          style: TextStyle(
                                              fontSize: 50,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 40),
                                        Text(
                                          "Spécification",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 24),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text("Marque : ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: AppColors().gray(),
                                                    )),
                                                Text(
                                                  '${widget.product.brand}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text("Quantity : ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: AppColors().gray(),
                                                    )),
                                                Text(
                                                  '${widget.product.quantity}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text("Catégorie : ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: AppColors().gray(),
                                                    )),
                                                Text(
                                                  '${widget.product.category.name}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (widget.product.quantity < 25)
                                          Column(
                                            children: [
                                              SizedBox(height: 15),
                                              Container(
                                                margin:
                                                const EdgeInsets.only(bottom: 16),
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: AppColors()
                                                      .red()
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColors()
                                                          .red()
                                                          .withOpacity(0.3)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.warning_amber_rounded,
                                                      color: AppColors().red(),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        "Stock limité! Il ne reste que ${widget.product.quantity} unités.",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppColors().red(),
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors().black(),
                                              foregroundColor: AppColors().white()),
                                          onPressed: () async {
                                            try {
                                              var response = await ApiService()
                                                  .addCartProducts(
                                                context,
                                                widget.product.id,
                                                ApiService.clientId,
                                                setState,
                                              );
                                              if (response ==
                                                      "Ce produit n'existe plus" ||
                                                  response ==
                                                      "Ce produit est épuisé") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(response)));
                                              }
                                            } finally {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.symmetric(vertical: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shopping_cart,
                                                  size: 16,
                                                  color: AppColors().white(),
                                                ),
                                                const SizedBox(width: 18),
                                                Text(
                                                  'Ajouter au panier',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 500,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color:
                                                AppColors().gray().withOpacity(0.3),
                                            width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                AppColors().gray().withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: widget.product.photo != null
                                          ? Image.network(widget.product.photo!,
                                              fit: BoxFit.contain)
                                          : Image.asset(
                                              'assets/images/placeholder_image.webp',
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 700,
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border(),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.product.name,
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 15),
                                        if (widget.product.sellingPrice < 25)
                                          Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: AppColors()
                                                      .green()
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.local_offer,
                                                      color: AppColors().green(),
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "Au plus bas prix !",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors().green(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                            ],
                                          ),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors().gray().withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Text(
                                            widget.product.description,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors().gray(),
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                        Text(
                                          "\$ " +
                                              widget.product.sellingPrice
                                                  .toString() +
                                              ".00",
                                          style: TextStyle(
                                              fontSize: 50,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 24),
                                        Text(
                                          "Spécification",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 24),
                                        Column(children: [
                                          Row(
                                            children: [
                                              Text("Marque : ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors().gray(),
                                                  )),
                                              Text(
                                                '${widget.product.brand}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text("Quantity : ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors().gray(),
                                                  )),
                                              Text(
                                                '${widget.product.quantity}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text("Catégorie : ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors().gray(),
                                                  )),
                                              Text(
                                                '${widget.product.category.name}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          if (widget.product.quantity < 25)
                                            Column(
                                              children: [
                                                SizedBox(height: 15),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.only(bottom: 16),
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: AppColors()
                                                        .red()
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    border: Border.all(
                                                        color: AppColors()
                                                            .red()
                                                            .withOpacity(0.3)),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.warning_amber_rounded,
                                                        color: AppColors().red(),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          "Stock limité! Il ne reste que ${widget.product.quantity} unités.",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: AppColors().red(),
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                        ]),
                                        Spacer(),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors().black(),
                                                foregroundColor:
                                                    AppColors().white()),
                                            onPressed: () async {
                                              try {
                                                var response = await ApiService()
                                                    .addCartProducts(
                                                  context,
                                                  widget.product.id,
                                                  ApiService.clientId,
                                                  setState,
                                                );
                                                if (response ==
                                                        "Ce produit n'existe plus" ||
                                                    response ==
                                                        "Ce produit est épuisé") {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(response)));
                                                }
                                              } finally {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.symmetric(vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.shopping_cart,
                                                    size: 16,
                                                    color: AppColors().white(),
                                                  ),
                                                  const SizedBox(width: 18),
                                                  Text(
                                                    'Ajouter au panier',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ],
                ),
              ),

              WebFooter()
            ],
          ),
        ),
      ),
    );
  }
}
