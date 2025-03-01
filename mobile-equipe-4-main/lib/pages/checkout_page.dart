import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/widgets/bottom_nav.dart';
import 'package:mobilelapincouvert/widgets/custom_app_bar.dart';

import '../widgets/cart_summary.dart';
import '../widgets/order_progress.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

final TextEditingController username_controller = TextEditingController();
final TextEditingController password_controller = TextEditingController();

class _CheckoutPageState extends State<CheckoutPage> {
  int _type = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Checkout', centerTitle: true,),
        body: buildBody(),
        bottomNavigationBar: navigationBar(context, 1, setState),
    );
  }

  Widget buildBody() {
    void handleRatio(Object? e) => setState(() {
          _type = e as int;
        });

    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Divider(
          color: Color(0xFFCFCFCF),
          indent: 20,
          endIndent: 20,
        ),
        Container(
          height: 40,
        ),
        Expanded(
          flex: 1,
          child: OrderProgress(
            activeStep: 2,
          ),
        ),
        Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 350,
                      height: 150,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        color: Color(0x802AB24A),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Informations de livraison",
                                style: TextStyle(
                                  color: Color(0xFF353535),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person_pin,
                                    color: Color(0xFF454545),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    "William Osuji",
                                    style: TextStyle(
                                        color: Color(0xFF454545),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.place,
                                    color: Color(0xFF454545),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    "D0621",
                                    style: TextStyle(
                                        color: Color(0xFF454545),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    color: Color(0xFF454545),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    "514-298-3480",
                                    style: TextStyle(
                                        color: Color(0xFF454545),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    Container(
                      width: 350,
                      height: 500,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),

                      ),
                      child: Container(
                        color: Color(0x80D98E04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Mode de paiement",
                                    style: TextStyle(
                                      color: Color(0xFF353535),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Icon(Icons.payment,
                                        color: Color(0xFF454545)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    )
                  ],
                ),
              ),
            )),
        const CartSummary(
          buttonText: "Paiement",
        ),
      ],
    );
  }
}
