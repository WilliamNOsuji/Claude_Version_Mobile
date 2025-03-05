import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_order_success_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/widgets/order_progress.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/order_success_page.dart';
import '../../generated/l10n.dart';
import '../../gestion_erreurs.dart';
import '../../models/colors.dart';
import '../../services/web_api_service.dart';

class WebCheckoutPage extends StatefulWidget {
  final List<CartProductDTO> listCartProducts;
  const WebCheckoutPage({super.key, required this.listCartProducts});

  @override
  _WebCheckoutPageState createState() => _WebCheckoutPageState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();
TextEditingController name_controller = TextEditingController();
TextEditingController adress_controller = TextEditingController();
TextEditingController phoneNumber_controller = TextEditingController();
bool _isButtonDisabled = false;

class _WebCheckoutPageState extends State<WebCheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WebCustomAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(150.0, 80, 80, 10),
                  child: Text(
                    "Vérification",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter'),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(150.0, 0, 150, 0),
                        child: Container(
                          height: 500,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: AppColors().green(),
                                      child: Icon(
                                        Icons.local_shipping,
                                        size: 20,
                                        color: AppColors().white(),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Informations de livraison",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors().black()),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Form(
                                  key: formkey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                          controller: name_controller,
                                          validator: (value) => errorNomComplet(context, name_controller.text),
                                          maxLength: 16,
                                          decoration: InputDecoration(
                                            hintText: S.of(context).nomComplet,
                                            label: Text(S.of(context).nomComplet),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors().gray(),
                                                    width: 1.0
                                                )
                                            ),)),
                                      SizedBox(width: 10),
                                      Text("Mes informations",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors().black()),
                                      ),
                                      TextFormField(
                                        controller: adress_controller,
                                        validator: (value) => errorLocal(context, adress_controller.text),
                                        maxLength: 16,
                                        decoration: InputDecoration(
                                          hintText: S.of(context).d0601,
                                          label: Text(S.of(context).local),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors().gray(),
                                                  width: 1.0
                                              )
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: phoneNumber_controller,
                                        validator: (value) => errorPhone(context, phoneNumber_controller.text),
                                        maxLength: 16,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: '(000) - 000 - 0000',
                                          label: Text('Télephone'),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors().gray(),
                                                  width: 1.0
                                              )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Spacer(),
                                ElevatedButton(
                                  onPressed: ()  {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors().gray(),

                                  ),
                                  child: Text(
                                    'Retour',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(80.0, 0, 80, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors().red(),
                                  child: Icon(
                                    Icons.fastfood,
                                    size: 20,
                                    color: AppColors().white(),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Vérifiez votre panier",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().black()),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Divider(),
                            ExpansionTile(
                              title: Text(
                                "${widget.listCartProducts.length} produits",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              children: widget.listCartProducts
                                  .map((item) => ListTile(
                                leading: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Image.network(
                                      item.imageUrl,
                                      fit: BoxFit.contain,
                                    )),
                                title: Text(item.name),
                                subtitle: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Nbr: ',
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        Text(item.quantity.toString())
                                      ],
                                    ),
                                    Text('  |  '),
                                    Row(
                                      children: [
                                        Text(
                                          'Prix: ',
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        Text(
                                            '${(item.quantity * item.prix).toStringAsFixed(2)} \$')
                                      ],
                                    )
                                  ],
                                ),
                              ))
                                  .toList(),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Sous-total',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '\$${ApiService().calculateFinalTotal(widget.listCartProducts).toStringAsFixed(2)}', // Display totalAmount
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        if(!_isButtonDisabled){
                                          buttonPayer();
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        backgroundColor: AppColors().black(),
                                      ),
                                      child: Text(
                                        'Paiement',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }

  Future<void> _handleWebPayment() async {
    try {
      // Validate cart products
      var validationResponse = await ApiService().validateCartProducts(context, widget.listCartProducts);

      if (validationResponse.toString() == "Le panier est valide") {
        // Store form data in ApiService
        ApiService.address = adress_controller.text;
        ApiService.phoneNum = phoneNumber_controller.text;

        // Get app base URL for success and cancel redirects
        final baseUrl = Uri.base.origin;

        // Create direct URLs without hash fragments for Stripe
        // Stripe will replace the {CHECKOUT_SESSION_ID} placeholder
        //final successUrl = '$baseUrl/order-success?session_id={CHECKOUT_SESSION_ID}';
        final successUrl = '$baseUrl/web-order-success';
        final cancelUrl = '$baseUrl/';

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        try {
          // Get checkout session URL using the StripeWebService
          final stripeService = WebApiService();
          final checkoutUrl = await stripeService.createCheckoutSession(
            amount: ApiService().calculateFinalTotal(widget.listCartProducts),
            currency: ApiService.currency,
            address: ApiService.address,
            phoneNum: ApiService.phoneNum,
            deviceTokens: [],
            successUrl: successUrl,
            cancelUrl: cancelUrl,
          );

          // Close loading dialog
          Navigator.of(context).pop();

          if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
            // Redirect to Stripe Checkout
            print("Redirecting to Stripe: $checkoutUrl");
            stripeService.redirectToCheckout(checkoutUrl);

            print('Hello');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create checkout session. Please try again.')),
            );
          }
        } catch (e) {
          // Close loading dialog if still open
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }

          print("Error during checkout session creation: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during checkout: ${e.toString()}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationResponse.toString())),
        );
      }
    } catch (e) {
      print("Error in _handleWebPayment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  Future<void> buttonPayer() async {
    if(formkey.currentState!.validate()) {
      setState(() {
        _isButtonDisabled = true; // Disable the button
      });
      print(adress_controller.text);
      print(phoneNumber_controller.text);

      try {
        ApiService.address = adress_controller.text;
        ApiService.phoneNum = phoneNumber_controller.text;

        if (kIsWeb) {
          await _handleWebPayment();
        }
      } catch(e) {
        setState(() {
          _isButtonDisabled = false; // Re-enable the button
        });
      }
    }
  }
}